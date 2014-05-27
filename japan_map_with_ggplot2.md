日本地図をR(ggplot2)で表示する。
========================================================

* 県、区（市）までのデータセットの整形。
* 地域名とIDのマッピングに苦戦した。（要確認）
* 本当は郵便番号と地域のマッピングもしたかった。

* Rの基本グラフィックス機能またはggplot2を使って地図を描くには
    * http://sudillap.hatenablog.com/entry/2013/03/26/210202
* Global Administrative Areas
    * http://www.gadm.org/country


```r
library(maptools)
library(spsurvey)

jpn <- readShapePoly("~/Downloads/JPN_adm/JPN_adm2.shp")
plot(jpn[jpn$NAME_1=="Tokyo",])
```

![plot of chunk map_test](figure/map_test1.png) 

```r

# head(unique(jpn$NAME_1))
# head(unique(jpn$ID_2))
# 
# jpn.tokyo <- subset(jpn,NAME_1=="Tokyo")
# unique(jpn.tokyo$NAME_2)
# unique(jpn.tokyo$ID_2)
#   pref_name = as.character(unique(jpn$NAME_1)),
#   pref_id   = as.character(unique(jpn$ID_1))

library("ggplot2")
library("maptools")
# jpn.tokyo <- subset(jpn,NAME_1=="Tokyo")
# map <- fortify(jpn.tokyo)
# head(map)
# unique(map$id)
# 
# dd <- data.frame(
#   name = subset(jpn,ID_2 %in% unique(map$id))$NAME_2,
#   id   = unique(map$id)
# )
# head(dd)
# map <- merge(map,dd,all.x=T)
# head(map)
# 
# summary(map)
# map <- map[order(map$group,map$order),]
# head(map)
# qplot(data=map,long,lat,group=group,fill=name,geom="polygon")+coord_fixed()

pref<-as.character(unique(jpn$NAME_1))
pref_test <- pref[42]
jpn.sub <- subset(jpn,NAME_1==pref_test)
map <- fortify(jpn.sub)
```

```
## Regions defined for each Polygons
```

```r
map_id <- unique(map$id)
dd <- data.frame(
  id   = map_id,
  name = subset(jpn,ID_2 %in% map_id)$NAME_2,
  pref_id = pref_test
)
head(dd)
```

```
##     id    name pref_id
## 1 1619 Arakawa   Tokyo
## 2 1620  Bunkyo   Tokyo
## 3 1621    Chuo   Tokyo
## 4 1622   Chofu   Tokyo
## 5 1623 Chiyoda   Tokyo
## 6 1624 Edogawa   Tokyo
```

```r
map.sub <- merge(map,dd,all.x=T)
head(map.sub)
```

```
##     id  long   lat order  hole piece  group    name pref_id
## 1 1619 139.3 35.82     1 FALSE     1 1619.1 Arakawa   Tokyo
## 2 1619 139.3 35.81     2 FALSE     1 1619.1 Arakawa   Tokyo
## 3 1619 139.3 35.80     3 FALSE     1 1619.1 Arakawa   Tokyo
## 4 1619 139.3 35.80     4 FALSE     1 1619.1 Arakawa   Tokyo
## 5 1619 139.3 35.79     5 FALSE     1 1619.1 Arakawa   Tokyo
## 6 1619 139.3 35.79     6 FALSE     1 1619.1 Arakawa   Tokyo
```

```r
map.sub <- map.sub[order(map.sub$id,map.sub$order),]
head(map.sub)
```

```
##     id  long   lat order  hole piece  group    name pref_id
## 1 1619 139.3 35.82     1 FALSE     1 1619.1 Arakawa   Tokyo
## 2 1619 139.3 35.81     2 FALSE     1 1619.1 Arakawa   Tokyo
## 3 1619 139.3 35.80     3 FALSE     1 1619.1 Arakawa   Tokyo
## 4 1619 139.3 35.80     4 FALSE     1 1619.1 Arakawa   Tokyo
## 5 1619 139.3 35.79     5 FALSE     1 1619.1 Arakawa   Tokyo
## 6 1619 139.3 35.79     6 FALSE     1 1619.1 Arakawa   Tokyo
```

```r
qplot(data=map.sub,long,lat,group=group,col=name,geom="polygon")+coord_fixed()+ggtitle(pref_test)
```

![plot of chunk map_test](figure/map_test2.png) 

```r

# for(i in pref[-1]){
#   jpn.sub <- subset(jpn,NAME_1==i)
#   dd <- data.frame(
#     pref_id=i,
#     name=unique(jpn.sub$NAME_2),
#     id=unique(jpn.sub$ID_2)
#   )
#   map.sub <- fortify(jpn.sub)
#   map.sub <- merge(map.sub,dd,all.x=T)
#   map.sub <- map[order(map.sub$id,map.sub$order),]
#   rbind(map,map.sub) ->> map
# }
# 
# head(map)
# summary(map)
# map <- map[order(map$id,map$order),]
# qplot(data=map,long,lat,group=group,fill=name,geom="polygon")+coord_fixed()+facet_wrap(~pref_id)
```

