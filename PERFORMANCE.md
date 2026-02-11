# Performance Recommendations

This document provides guidance on optimizing performance when using the hanwoo package.

## API Call Optimization

### Batch Processing with `hanwoo_info()`

When retrieving data for multiple cattle, avoid sequential calls in a simple loop. Instead, use parallel processing or batch your requests efficiently:

**Not Recommended:**
```r
# Sequential processing - slow for large datasets
results <- list()
for (i in seq_along(cattle_ids)) {
  results[[i]] <- hanwoo_info(cattle_ids[i], key_encoding, key_decoding)
}
```

**Recommended:**
```r
# Use purrr::map with error handling for cleaner code
library(purrr)

# Option 1: Sequential with progress bar (requires pbapply package)
# install.packages("pbapply")
library(pbapply)
results <- pblapply(cattle_ids, function(x) {
  tryCatch(
    hanwoo_info(x, key_encoding, key_decoding),
    error = function(e) NULL
  )
})

# Option 2: Parallel processing with furrr (use with caution to avoid API rate limits)
# install.packages("furrr")
library(furrr)
plan(multisession, workers = 4)  # Adjust workers based on API limits
results <- future_map(cattle_ids, function(x) {
  tryCatch(
    hanwoo_info(x, key_encoding, key_decoding),
    error = function(e) NULL
  )
}, .progress = TRUE)
```

### Rate Limiting

When making many API calls, implement rate limiting to avoid overloading the server:

```r
# Add delays between requests
results <- map(cattle_ids, function(x) {
  result <- tryCatch(
    hanwoo_info(x, key_encoding, key_decoding),
    error = function(e) NULL
  )
  Sys.sleep(0.5)  # 500ms delay between requests
  return(result)
})
```

### Caching Results

For frequently accessed data, cache results to avoid repeated API calls:

```r
# Simple file-based caching
cache_dir <- "cache"
if (!dir.exists(cache_dir)) dir.create(cache_dir)

get_cached_info <- function(cattle_id, key_encoding, key_decoding) {
  cache_file <- file.path(cache_dir, paste0(cattle_id, ".rds"))
  
  if (file.exists(cache_file)) {
    # Check if cache is less than 24 hours old
    if (difftime(Sys.time(), file.mtime(cache_file), units = "hours") < 24) {
      return(readRDS(cache_file))
    }
  }
  
  # Fetch fresh data
  result <- hanwoo_info(cattle_id, key_encoding, key_decoding)
  saveRDS(result, cache_file)
  return(result)
}
```

## Data Processing Optimization

### Efficient Data Extraction

When you only need specific fields from the results, extract them early:

```r
# Extract only quality_info from multiple cattle
quality_data <- map_df(cattle_ids, function(x) {
  result <- tryCatch(
    hanwoo_info(x, key_encoding, key_decoding)$quality_info,
    error = function(e) NULL
  )
  return(result)
})
```

### Vectorized Operations

Use vectorized operations with `req_steer()` and `req_bull()`:

```r
# Instead of loops, use map functions
library(purrr)
library(dplyr)

# Vectorized nutrient requirements calculation
df <- data.frame(
  month = 6:15,
  weight = c(160, 184, 208, 233, 258, 284, 310, 337, 366, 395),
  daily_gain = c(0.8, 0.8, 0.8, 0.9, 0.9, 0.9, 0.9, 1, 1, 1)
)

# Efficient calculation
requirements <- map2_df(df$weight, df$daily_gain, req_steer)
```

## Memory Management

### Process Data in Chunks

For large datasets, process data in chunks to manage memory:

```r
# Process cattle IDs in batches
chunk_size <- 100
cattle_chunks <- split(cattle_ids, ceiling(seq_along(cattle_ids) / chunk_size))

all_results <- list()
for (i in seq_along(cattle_chunks)) {
  chunk_results <- map(cattle_chunks[[i]], function(x) {
    tryCatch(
      hanwoo_info(x, key_encoding, key_decoding),
      error = function(e) NULL
    )
  })
  
  # Extract and save only needed data, then clear memory
  all_results[[i]] <- map_df(chunk_results, ~ .x$quality_info)
  rm(chunk_results)
  gc()  # Garbage collection
  
  Sys.sleep(5)  # Pause between chunks
}

final_result <- bind_rows(all_results)
```

## Performance Monitoring

### Use Time Checks

The `hanwoo_info()` function includes a built-in timing feature:

```r
# Enable time checking
result <- hanwoo_info(
  cattle = "002083191603",
  key_encoding = key_encoding,
  key_decoding = key_decoding,
  time_check = TRUE
)
# Outputs: "서버 응답 시간: X.XX secs"
```

### Benchmark Your Code

Use `microbenchmark` to compare different approaches:

```r
library(microbenchmark)

# Compare different methods
microbenchmark(
  sequential = map(sample_ids, ~ hanwoo_info(.x, key_encoding, key_decoding)),
  with_cache = map(sample_ids, ~ get_cached_info(.x, key_encoding, key_decoding)),
  times = 5
)
```

## API Best Practices

1. **Respect Rate Limits**: Add appropriate delays between API calls
2. **Handle Errors Gracefully**: Always use `tryCatch()` for API calls
3. **Cache When Possible**: Store results locally for frequently accessed data
4. **Filter Early**: Request only the data you need
5. **Process in Parallel**: Use parallel processing for independent operations (with caution)
6. **Monitor Response Times**: Use the `time_check` parameter to identify slow operations
7. **Clean Up Resources**: Use `gc()` to free memory when processing large datasets

## Code Optimizations Already Implemented

The following optimizations have been implemented in version 0.2.1+:

1. **Reduced String Concatenation**: Base URL patterns are cached in `hanwoo_info()`
2. **Consolidated Type Conversions**: Type conversions are performed once instead of multiple times
3. **Early Returns**: Functions return early when no data is available, avoiding unnecessary processing
4. **Efficient Data Binding**: Uses `bind_rows()` instead of deprecated `plyr` functions

## Troubleshooting Performance Issues

If you experience slow performance:

1. Check your internet connection and API server response times
2. Verify API key validity and permissions
3. Reduce the number of concurrent requests
4. Use caching for repeated queries
5. Process data in smaller batches
6. Monitor memory usage with `pryr::mem_used()`

For additional help, please submit an issue at: https://github.com/adatalab/hanwoo/issues
