.onAttach <- function(...) {
  withr::with_preserve_seed({
    # if (!interactive() || stats::runif(1) > 0.1) return()

    tips <- c(
      "Welcome animal scientist!",
      "https://github.com/adatalab/hanwoo",
      "Hanwoo. The best beef on Earth.",
      "For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life. (John 3:16)",
      "Religion that God our Father accepts as pure and faultless is this: to look after orphans and widows in their distress and to keep oneself from being polluted by the world. (James 1:27)",
      "Tip: 갓 태어난 송아지의 몸에 묻어 있는 양수 및 오물은 가능하면 어미가 핥아 주도록 하는 것이 좋습니다. 그렇지 못할 때에는 수건 등으로 깨끗하게 닦아주고 보온등을 쬐어 빨리 마르게 합니다.",
      "Tip: 송아지는 추위에 약하므로 환경온도가 10도씨 밑으로 내려가지 않도록 보온에 유의해야 합니다. 기상상태가 좋으면 운동장에서 자유롭게 운동할 수 있도록 하고 물은 신선한 것으로 자유롭게 먹을 수 있도록 합니다.",
      "Tip: 출생한 송아지가 허약할 때에는 비타민제제나 항생제를 투여합니다. 설사하는 송아지는 전해질 제제를 투여해 체력을 보충해 줍니다.",
      "Tip: 초유는 2일 이내에 분비되는 우유로 송아지가 면역물질을 받을 수 있는 유일한 통로입니다. 초유는 송아지 분만 후 30-40분 이내에 급여하거나 포유할 수 있도록 도와줘야 합니다. 처음 태어난 송아지가 하루동안 섭취해야 하는 초유의 양은 송아지 체중의 4-5%를 24시간 이내에 섭취할 수 있도록 도와주어야 합니다."
    )

    tip <- sample(tips, 1)
    packageStartupMessage(paste(strwrap(tip), collapse = "\n"))
  })
}
