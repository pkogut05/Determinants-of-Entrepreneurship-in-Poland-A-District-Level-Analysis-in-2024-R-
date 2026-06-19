install.packages("readxl")
install.packages("dplyr")
install.packages("car")
install.packages("lmtest")
install.packages("sandwich")
install.packages("broom")
install.packages("corrplot")
install.packages("tseries")
install.packages("moments")

# Pakiety
library(readxl)
library(dplyr)
library(car)        
library(lmtest)  
library(sandwich)  
library(broom)      
library(corrplot)  
library(tseries)
library(moments)

# 1) Wczytanie danych
df <- read_excel("Dane2024.xlsx")
df <- df[, !grepl("^\\.\\.\\.", names(df))]

#1.1)Miary statystyczne zmiennych
zmienne <- c("Y","X1","X2","X3","X4","X5")
Tabela1 <- data.frame(
  Zmienna = zmienne,
  N = sapply(df[zmienne], length),
  Srednia = sapply(df[zmienne], mean),
  Mediana = sapply(df[zmienne], median),
  Odch_stand = sapply(df[zmienne], sd),
  Min = sapply(df[zmienne], min),
  Max = sapply(df[zmienne], max),
  Rozstep = sapply(df[zmienne], function(x) max(x) - min(x)),
  Blad_stand = sapply(df[zmienne], function(x) sd(x) / sqrt(length(x))),
  Skosnosc = sapply(df[zmienne], skewness),
  Kurtoza  = sapply(df[zmienne], kurtosis)
)

Tabela1 <- round(Tabela1, 2)
Tabela1
#1.2)histogram jednostki nowo zarejestrowane w rejestrze REGON na 10 tys. Ludności
y <- df$Y
hist(y,
     breaks = 50,
     probability = TRUE,   
     main = "Rozkład nowo zarejestrowane podmioty gospodarcze na 10 tys. Ludności",
     xlab = "Nowo zarejestrowane podmioty gospodarcze na 10 tys. Ludności",
     col = "pink1",
     border = "white")
#1.3)Y z X5
par(mfrow = c(1, 1))
najw_Xcor<-"X5"
plot(df[[najw_Xcor]], df$Y,
     xlab = "podmioty wpisane do rejestru REGON na 10 tys. ludności",
     ylab = "Nowo zarej. podmioty gospodarcze na 10 tys. Ludności",
     main = paste("Zależność między", "X5", "a Y"),
     pch = 19, col = "steelblue")

abline(lm(df$Y ~ df[[najw_Xcor]]), col = "red", lwd = 2)

lines(density(y), lwd = 1)

# 2) Model KMNK,wykresy zależności i macierz korelacji
model <- lm(Y~X1+X2+X3+X4+X5, data = df)
summary(model)
kor <- cor(df[, c("Y", "X1", "X3", "X4", "X5")])
kor_df <- data.frame(Zmienna = rownames(kor), kor, row.names = NULL)
kor_df
#tabela współczynników
tab <- summary(model)$coefficients

tabela_modelu <- data.frame(
  Zmienna = rownames(tab),
  Estymator = tab[, 1],
  Blad_stand = tab[, 2],
  Statystyka_t = tab[, 3],
  p_value = tab[, 4],
  row.names = NULL
)
#Parametry(R^2, skorygowane R^2, Błąd standardowy,stopnie swobody,statystyka F, p-value dla testy F)
suma_m2 <- summary(model)
dop <- data.frame(
  RSE = suma_m2$sigma,
  R2 = suma_m2$r.squared,
  R2_adj = suma_m2$adj.r.squared,
  F = suma_m2$fstatistic[1],
  p_F = pf(suma_m2$fstatistic[1], suma_m2$fstatistic[2], suma_m2$fstatistic[3], lower.tail = FALSE)
)

par(mfrow = c(2, 3))
plot(df$X1, df$Y,
     xlab = "X1", ylab = "Y",
     main = "Y vs X1", pch = 19, col = "steelblue")
abline(lm(Y ~ X1, data = df), col = "red", lwd = 2)

plot(df$X2, df$Y,
     xlab = "X2", ylab = "Y",
     main = "Y vs X2", pch = 19, col = "steelblue")
abline(lm(Y ~ X2, data = df), col = "red", lwd = 2)

plot(df$X3, df$Y,
     xlab = "X3", ylab = "Y",
     main = "Y vs X3", pch = 19, col = "steelblue")
abline(lm(Y ~ X3, data = df), col = "red", lwd = 2)

plot(df$X4, df$Y,
     xlab = "X4", ylab = "Y",
     main = "Y vs X4", pch = 19, col = "steelblue")
abline(lm(Y ~ X4, data = df), col = "red", lwd = 2)

plot(df$X5, df$Y,
     xlab = "X5", ylab = "Y",
     main = "Y vs X5", pch = 19, col = "steelblue")
abline(lm(Y ~ X5, data = df), col = "red", lwd = 2)
p <- summary(model)$coefficients[-1, 4] 
if (max(p) > 0.05) {
  do_usuniecia <- names(p)[which.max(p)]
  cat("Usuwam:", do_usuniecia, " bo p =", max(p), "\n")
  
  form2 <- as.formula(paste("Y ~", paste(setdiff(names(p), do_usuniecia), collapse = " + ")))
  model2 <- lm(form2, data = df)
  summary(model2)
} else {
  cat("Wszystkie zmienne są istotne (p<=0.05)\n")
  summary(model)
}
#Parametry po odrzuceniu zmiennej X2(R^2, skorygowane R^2, Błąd standardowy,stopnie swobody,statystyka F, p-value dla testy F)
suma_m3 <- summary(model2)
dop2 <- data.frame(
  RSE = suma_m3$sigma,
  R2 = suma_m3$r.squared,
  R2_adj = suma_m3$adj.r.squared,
  F = suma_m3$fstatistic[1],
  p_F = pf(suma_m3$fstatistic[1], suma_m3$fstatistic[2], suma_m3$fstatistic[3], lower.tail = FALSE)
)
#tabela współczynników 2 
tab2 <- summary(model2)$coefficients

tabela_modelu <- data.frame(
  Zmienna = rownames(tab),
  Estymator = tab[, 1],
  Blad_stand = tab[, 2],
  Statystyka_t = tab[, 3],
  p_value = tab[, 4],
  row.names = NULL
)

# Test normalności reszt Jarque–Bera
jb_test <- jarque.bera.test(residuals(model2))
jb_test
#Test autokorelacji
DB<-dwtest(model2)
DB
reszty<-residuals(model2)

# Reszty vs Wartości dopasowane
plot(fitted(model2), residuals(model2),
     xlab = "Wartości dopasowane",
     ylab = "Reszty",
     main = "Wykres reszt vs wartości dopasowane",
     pch = 19, col = "steelblue")
abline(h = 0, col = "red", lwd = 2)
#test homoskedastycznosci
GQ <- gqtest(model2, order.by = fitted(model2), fraction = 0.2)
print(GQ)
#odporne błędy standardowe
robust_test <- coeftest(model2, vcov = vcovHC(model2, type = "HC1"))
robust_test
#Test modeli zagnieżdżonych/test F zeby sprawdzic czy zmienna X3 istotnie poprawia dopasowanie modelu
model_bez_X3 <- update(model2, . ~ . - X3)
anova(model_bez_X3, model2)
