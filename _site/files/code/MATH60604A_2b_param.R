library(hecstatmod)
summary(lm(lognuser ~ celcius, data = bixicoll))
summary(lm(lognuser ~ farenheit, data = bixicoll))
summary(lm(lognuser ~ celcius + farenheit, data = bixicoll))
