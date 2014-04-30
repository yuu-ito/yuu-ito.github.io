# refs 
# - http://ww2.coastal.edu/kingw/statistics/R-tutorials/loglin.html

data(Titanic)
# ?Titanic
dimnames(Titanic)

require(graphics)
mosaicplot(Titanic, main = "Survival on the Titanic")

margin.table(Titanic, c(2,4))

# オッズ比
(odds_male_survived <- 367/1364)
(odds_female_survived <- 344/126)
(odds_rate_F <-odds_female_survived/odds_male_survived) # 女性である場合、10倍の確率で生存する。

# 尤度比、リスク比
(344/(344+126)) / (367/(367+1364))


t <- Titanic
t.df <- data.frame(t)
names(t.df) <- tolower(names(t.df))

require("reshape2")
t.cast.df <- dcast(t.df,class+sex+age~survived,value.var="freq")
(t.cast.df)
str(t.cast.df)

t.glm <- glm(cbind(Yes,No)~class+sex+age, family=binomial, data=t.cast.df)
summary(t.glm)

# stepAICによる変数選択
t.glm <- glm(cbind(Yes,No)~(.)^2, family=binomial, data=t.cast.df)

require("MASS")
stepAIC(t.glm)



