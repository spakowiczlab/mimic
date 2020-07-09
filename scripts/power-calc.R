

water.u <- 140
water.ci <- 10 
  

cc.u <- 70
cc.ci <- 10
  
# 10 mice in Routy

power.t.test(delta = (water.u - cc.u),
             sd = 10,
             alternative = "one.sided",
             sig.level = 0.05,
             power = 0.8)

power.t.test(delta = water.u * 0.15,
             sd = 15,
             # type = "paired",
             alternative = "one.sided",
             sig.level = 0.05,
             n = 10)
