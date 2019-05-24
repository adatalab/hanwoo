.onAttach <- function(...) {
  withr::with_preserve_seed({
    # if (!interactive() || stats::runif(1) > 0.1) return()
    
    tips <- c(
      "Hi buddy!",
      "Welcome animal scientist!",
      "It's not your fault.",
      "https://github.com/adatalab/hanwoo",
      "Hanwoo. The best beef on Earth.",
      "For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life. (John 3:16)",
      "Religion that God our Father accepts as pure and faultless is this: to look after orphans and widows in their distress and to keep oneself from being polluted by the world. (James 1:27)"
    )
    
    tip <- sample(tips, 1)
    packageStartupMessage(paste(strwrap(tip), collapse = "\n"))
  })
}