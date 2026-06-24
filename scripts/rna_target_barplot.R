#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(stringr)
  library(ggplot2)
  library(scales)
  library(grid)
})

parse_args <- function(args) {
  out <- list()
  for (arg in args) {
    if (arg == "--self-test") {
      out$self_test <- TRUE
    } else if (grepl("=", arg, fixed = TRUE)) {
      pieces <- strsplit(arg, "=", fixed = TRUE)[[1]]
      key <- pieces[1]
      value <- paste(pieces[-1], collapse = "=")
      out[[key]] <- value
    }
  }
  out
}

get_arg <- function(args, key, default = NULL, required = FALSE) {
  value <- args[[key]]
  if (is.null(value) || identical(value, "")) {
    if (required) stop("Missing required argument: ", key)
    return(default)
  }
  value
}

clean_filename <- function(x) {
  x <- gsub("[^A-Za-z0-9_.-]", "_", x)
  gsub("_+", "_", x)
}

format_p_value <- function(p) {
  if (is.na(p)) return("NA")
  formatC(p, format = "e", digits = 2)
}

make_p_label <- function(p_value_column, p_value) {
  p_text <- format_p_value(p_value)
  if (p_value_column %in% c("padj", "p_adj", "P.adj", "P_adj", "qvalue")) {
    return(paste0("italic(P)[adj]~\"= \"~\"", p_text, "\""))
  }
  paste0("italic(P)~\"= \"~\"", p_text, "\"")
}

theme_target_barplot <- function(base_size = 6, base_family = "sans") {
  theme_classic(base_size = base_size, base_family = base_family) +
    theme(
      axis.line = element_line(linewidth = 0.176, colour = "black"),
      axis.ticks = element_line(linewidth = 0.176, colour = "black"),
      axis.ticks.length = unit(1.1, "mm"),
      axis.text = element_text(colour = "black", size = base_size),
      axis.title = element_text(colour = "black", size = base_size),
      axis.title.x = element_blank(),
      panel.grid = element_blank(),
      panel.border = element_blank(),
      plot.title = element_blank(),
      legend.position = "none",
      plot.margin = margin(4, 5, 4, 5)
    )
}

save_pdf_plot <- function(plot, filename, width_mm, height_mm) {
  grDevices::cairo_pdf(
    filename = filename,
    width = width_mm / 25.4,
    height = height_mm / 25.4,
    family = "sans"
  )
  print(plot)
  dev.off()
}

check_required_columns <- function(df, required_cols, df_name) {
  missing_cols <- setdiff(required_cols, names(df))
  if (length(missing_cols) > 0) {
    stop(df_name, " is missing required columns: ", paste(missing_cols, collapse = ", "))
  }
}

read_named_vector <- function(x, default) {
  if (is.null(x) || identical(x, "")) return(default)
  pairs <- strsplit(x, ",", fixed = TRUE)[[1]]
  values <- character()
  for (pair in pairs) {
    pieces <- strsplit(pair, ":", fixed = TRUE)[[1]]
    if (length(pieces) != 2) stop("Expected name:value pairs, got: ", pair)
    values[pieces[1]] <- pieces[2]
  }
  values
}

detect_sample_columns <- function(df, sample_prefix) {
  sample_cols <- list()
  for (group_name in names(sample_prefix)) {
    prefix <- sample_prefix[[group_name]]
    pattern <- paste0("^", prefix, "[0-9]+$")
    cols <- names(df)[str_detect(names(df), pattern)]
    if (length(cols) == 0) {
      stop("No replicate columns found for group '", group_name, "'. Expected names like ", prefix, "1.")
    }
    sample_num <- suppressWarnings(as.numeric(str_remove(cols, paste0("^", prefix))))
    cols <- cols[order(sample_num)]
    sample_cols[[group_name]] <- cols
  }
  sample_cols
}

calculate_y_layout <- function(data_y_max) {
  if (!is.finite(data_y_max) || is.na(data_y_max) || data_y_max <= 0) data_y_max <- 1
  plot_y_max <- max(data_y_max / 0.68, 1)
  list(
    plot_y_max = plot_y_max,
    line_y = plot_y_max * 0.76,
    p_text_y = plot_y_max * 0.86,
    gene_name_y = plot_y_max * 0.94
  )
}

make_self_test_files <- function(base_dir) {
  dir.create(base_dir, recursive = TRUE, showWarnings = FALSE)
  expr <- data.frame(
    id = c("gene_id_1", "gene_id_2"),
    name = c("Gene one", "Gene two"),
    Control1 = c(10, 6),
    Control2 = c(12, 7),
    Control3 = c(9, 5),
    Treatment1 = c(24, 9),
    Treatment2 = c(22, 12),
    Treatment3 = c(27, 11),
    check.names = FALSE
  )
  diff <- data.frame(
    id = c("gene_id_1", "gene_id_2"),
    pvalue = c(0.000034, 0.0123),
    check.names = FALSE
  )
  targets <- data.frame(
    id = c("gene_id_1", "gene_id_2"),
    name = c("GENE1", "GENE2"),
    check.names = FALSE
  )
  write.csv(expr, file.path(base_dir, "rna_expression_matrix.csv"), row.names = FALSE)
  write.csv(diff, file.path(base_dir, "rna_differential_results.csv"), row.names = FALSE)
  write.csv(targets, file.path(base_dir, "target_genes.csv"), row.names = FALSE)
}

run_barplots <- function(args) {
  if (isTRUE(args$self_test)) {
    base_dir <- file.path(tempdir(), paste0("bio_paper_figure_self_test_", Sys.getpid()))
    make_self_test_files(base_dir)
    args$expr_file <- file.path(base_dir, "rna_expression_matrix.csv")
    args$diff_file <- file.path(base_dir, "rna_differential_results.csv")
    args$target_file <- file.path(base_dir, "target_genes.csv")
    args$output_dir <- file.path(base_dir, "out")
  }

  expr_file <- get_arg(args, "expr_file", required = TRUE)
  diff_file <- get_arg(args, "diff_file", required = TRUE)
  target_file <- get_arg(args, "target_file", required = TRUE)
  output_dir <- get_arg(args, "output_dir", "target_gene_barplots")
  p_value_column <- get_arg(args, "p_value_column", "pvalue")
  errorbar_type <- get_arg(args, "errorbar_type", "SD")
  plot_width_mm <- as.numeric(get_arg(args, "plot_width_mm", "26"))
  plot_height_mm <- as.numeric(get_arg(args, "plot_height_mm", "36"))
  y_label <- get_arg(args, "y_label", "log2(TPM + 1)")

  group_order <- strsplit(get_arg(args, "group_order", "Control,Treatment"), ",", fixed = TRUE)[[1]]
  sample_prefix <- read_named_vector(get_arg(args, "sample_prefix", NULL), setNames(group_order, group_order))
  group_colors <- read_named_vector(
    get_arg(args, "group_colors", NULL),
    c(Control = "#D4D4D4", Treatment = "#298ACA")
  )

  if (!errorbar_type %in% c("SD", "SEM", "none")) stop("errorbar_type must be SD, SEM, or none")
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

  expr_df <- read.csv(expr_file, header = TRUE, check.names = FALSE, stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")
  diff_df <- read.csv(diff_file, header = TRUE, check.names = FALSE, stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")
  target_genes <- read.csv(target_file, header = TRUE, check.names = FALSE, stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")

  check_required_columns(expr_df, c("id", "name"), "Expression table")
  check_required_columns(diff_df, c("id", p_value_column), "Differential result table")
  check_required_columns(target_genes, c("id", "name"), "Target gene table")
  if (nrow(target_genes) == 0) stop("Target gene table is empty")

  sample_cols_by_group <- detect_sample_columns(expr_df, sample_prefix)
  sample_cols <- unlist(sample_cols_by_group, use.names = FALSE)
  if (any(lengths(sample_cols_by_group) < 2) && errorbar_type != "none") {
    stop("At least two replicates per group are required when error bars are used")
  }

  plot_one_gene <- function(gene_id, gene_name) {
    expr_row <- expr_df %>% filter(str_to_upper(id) == str_to_upper(gene_id))
    diff_row <- diff_df %>% filter(str_to_upper(id) == str_to_upper(gene_id))
    if (nrow(expr_row) != 1) stop("Expression table must match exactly one row for gene ID: ", gene_id)
    if (nrow(diff_row) != 1) stop("Differential result table must match exactly one row for gene ID: ", gene_id)

    p_value <- suppressWarnings(as.numeric(diff_row[[p_value_column]][1]))
    if (is.na(p_value)) stop("P value is missing or non-numeric for gene ID: ", gene_id)
    p_label <- make_p_label(p_value_column, p_value)

    plot_df <- expr_row %>%
      select(all_of(sample_cols)) %>%
      pivot_longer(cols = everything(), names_to = "Sample", values_to = "Expression") %>%
      mutate(Expression = suppressWarnings(as.numeric(Expression)))

    if (any(is.na(plot_df$Expression))) stop("Expression contains non-numeric values for gene ID: ", gene_id)
    if (any(plot_df$Expression < 0, na.rm = TRUE)) stop("Expression contains negative values for gene ID: ", gene_id)

    plot_df$Group <- NA_character_
    for (group_name in names(sample_cols_by_group)) {
      plot_df$Group[plot_df$Sample %in% sample_cols_by_group[[group_name]]] <- group_name
    }
    plot_df <- plot_df %>% mutate(Group = factor(Group, levels = group_order), Plot_value = log2(Expression + 1))

    summary_df <- plot_df %>%
      group_by(Group) %>%
      summarise(
        mean_value = mean(Plot_value, na.rm = TRUE),
        sd_value = sd(Plot_value, na.rm = TRUE),
        sem_value = sd_value / sqrt(n()),
        n = n(),
        .groups = "drop"
      ) %>%
      mutate(
        error_value = case_when(
          errorbar_type == "SD" ~ sd_value,
          errorbar_type == "SEM" ~ sem_value,
          TRUE ~ 0
        ),
        ymin = pmax(mean_value - error_value, 0),
        ymax = mean_value + error_value
      )

    data_y_max <- max(summary_df$ymax, plot_df$Plot_value, na.rm = TRUE)
    y_layout <- calculate_y_layout(data_y_max)
    plot_y_max <- y_layout$plot_y_max
    gene_box_ymin <- y_layout$gene_name_y - plot_y_max * 0.035
    gene_box_ymax <- y_layout$gene_name_y + plot_y_max * 0.035

    p <- ggplot() +
      geom_col(
        data = summary_df,
        aes(x = Group, y = mean_value, fill = Group),
        width = 0.58,
        colour = NA,
        alpha = 0.95
      ) +
      {
        if (errorbar_type != "none") {
          geom_errorbar(
            data = summary_df,
            aes(x = Group, ymin = ymin, ymax = ymax),
            width = 0.18,
            linewidth = 0.176,
            colour = "black"
          )
        }
      } +
      geom_jitter(
        data = plot_df,
        aes(x = Group, y = Plot_value, fill = Group),
        width = 0.08,
        size = 1.7,
        shape = 21,
        stroke = 0.176,
        colour = "black",
        alpha = 0.9
      ) +
      geom_segment(
        aes(x = 1.15, xend = length(group_order) - 0.15, y = y_layout$line_y, yend = y_layout$line_y),
        inherit.aes = FALSE,
        linewidth = 0.176,
        colour = "black"
      ) +
      annotate("rect", xmin = -Inf, xmax = Inf, ymin = gene_box_ymin, ymax = gene_box_ymax, fill = "#E0E0DF", colour = NA) +
      annotate("text", x = mean(seq_along(group_order)), y = y_layout$gene_name_y, label = gene_name, fontface = "italic", size = 6 / .pt, colour = "black") +
      annotate("text", x = mean(seq_along(group_order)), y = y_layout$p_text_y, label = p_label, parse = TRUE, size = 6 / .pt, colour = "black") +
      scale_fill_manual(values = group_colors) +
      scale_y_continuous(limits = c(0, plot_y_max), breaks = pretty_breaks(n = 4), expand = expansion(mult = c(0, 0))) +
      coord_cartesian(clip = "off") +
      labs(x = NULL, y = y_label) +
      theme_target_barplot()

    output_file <- file.path(output_dir, paste0("barplot_", clean_filename(gene_name), "_", clean_filename(gene_id), ".pdf"))
    save_pdf_plot(p, output_file, plot_width_mm, plot_height_mm)

    data.frame(
      id = gene_id,
      input_name = gene_name,
      matched_name = expr_row$name[1],
      p_value_column = p_value_column,
      p_value = p_value,
      errorbar_type = errorbar_type,
      output_file = output_file,
      stringsAsFactors = FALSE
    )
  }

  plot_report <- lapply(seq_len(nrow(target_genes)), function(i) {
    plot_one_gene(target_genes$id[i], target_genes$name[i])
  }) %>% bind_rows()

  report_file <- file.path(output_dir, "batch_barplot_report.csv")
  write.csv(plot_report, report_file, row.names = FALSE)

  cat("Batch barplot finished.\n")
  cat("Expression file:", expr_file, "\n")
  cat("Differential result file:", diff_file, "\n")
  cat("Target file:", target_file, "\n")
  cat("Output directory:", output_dir, "\n")
  cat("Number of genes plotted:", nrow(plot_report), "\n")
  cat("Bar height: mean log2(expression + 1)\n")
  cat("Error bar:", errorbar_type, "\n")
  cat("Report file:", report_file, "\n")
  if (isTRUE(args$self_test)) cat("Self-test output kept in:", output_dir, "\n")
  invisible(plot_report)
}

args <- parse_args(commandArgs(trailingOnly = TRUE))
run_barplots(args)
