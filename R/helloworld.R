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
      "Tip: 초유는 2일 이내에 분비되는 우유로 송아지가 면역물질을 받을 수 있는 유일한 통로입니다. 초유는 송아지 분만 후 30-40분 이내에 급여하거나 포유할 수 있도록 도와줘야 합니다. 처음 태어난 송아지가 하루동안 섭취해야 하는 초유의 양은 송아지 체중의 4-5%를 24시간 이내에 섭취할 수 있도록 도와주어야 합니다.",
      "Tip: 육종가(Expected Breeding Value; EBV)는 해당 동물이 종축으로써 가지는 가치를 나타냅니다.",
      "Tip: 육종가는 동물이 속해 있는 집단의 평균에 대한 상대값입니다. 만약 한우의 도체중 육종가가 +20kg 이라는 것은 그 가축의 도체중이 해당 가축이 속한 집단의 평균보다 20kg 무겁다라는 것을 의미합니다. hanwoo package에서는 hanwoo_bull() 함수를 이용해 한우의 육종가를 조회할 수 있습니다.",
      "Tip: 육종가는 전체집단의 평균과의 차이를 나타내기 때문에 육종가를 계산할 당시의 전체집단에 따라 값이 달라집니다. 한우보증 씨수소의 경우 1년 2회 육종가를 계산합니다. 그러므로 육종가는 같은 시기에 같이 평가한 개체에 대해서만 비교해야합니다.",
      "Tip: EPD(Expected Progeny Difference; 기대자손능력차)는 동물이 자손을 생산하게 될 때 물려줄 수 있는 유전적인 가치를 의미합니다. 이는 육종가(EBV)의 절반입니다. hanwoo package에서는 hanwoo_bull() 함수를 이용해 한우의 육종가를 조회할 수 있습니다.",
      "Tip: SBV(Standized Breeding Value; 표준화육종가)는 각 형질별 육종가의 단위와 분포를 표준화시켜 각 형질을 서로 비교할 수 있게 만든 육종가입니다. 단위를 없애고 각 형질을 1:1로 비교할수 있습니다.",
      "Tip: 국립축산과학원에서는 1년에 2번(2월, 8월) 홈페이지를 통해 보증씨수소의 육종가와 함께 교배계획길라잡이 프로그램을 제공하고 있습니다.",
      "Tip: 한우 암소의 최초발정시기는 생후 263일 내외(8-10개월)입니다. 이 때 평균 체중은 182kg 내외이며 성성숙에 도달하는 시기는 12개월령 내외로 체중이 200-250kg 정도 다다릅니다. 번식적기는 14개월 이후로 한우 암소의 발육이 안정화된 시기입니다. 체중이 260kg 이상일 때 번식을 시작하는 것이 좋으며 발육이 부진할 경우 2-3개월 정도 더 사육한 이후에 번식에 사용하는 것이 좋습니다."
    )

    tip <- sample(tips, 1)
    packageStartupMessage(paste(strwrap(tip), collapse = "\n"))
  })
}
