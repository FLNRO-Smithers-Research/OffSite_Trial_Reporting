# Create fake Data
 
library(tidyverse)
library(lubridate)

fidList=c("FID15","FID11","FID6","FID2M")
sppList=c("Sx","Pli","Fdi","Lw","Cw")
seedLot=c("A","B","C")
condList=c("Good","Fair","Poor","Moribund","Dead","Missing")

n.row=2160

    
year1Dat<-  
        tibble(FID=rep(fidList,each=540),
         Plot=rep(1:15,each=36,length.out=n.row),
         Row=rep(1:6,each=6,length.out=n.row),
         Column=rep(c(1:6,6:1),length.out=n.row),
         Date=rep(mdy("10-22-2019"),length.out=n.row),
         Species=rep(sppList,each=36*3,length.out=n.row),
         Seedlot=rep(seedLot,each=36,length.out=n.row),
         TreeID=rep(1:36,length.out=n.row),
         Height=runif(n.row,min=10,max=30),
         Diameter=runif(n.row,min=5,max=17),
         Condition=sample(condList,size=n.row, replace = TRUE, prob = c(80,8,5,2,3,3)),
         Dmg.Agent=NA,
         Dmg.Severity=NA,
         Comments=NA) %>% 
          mutate(Height=replace(Height,Condition=="Missing",NA)) %>% 
          mutate(Diameter=replace(Diameter,Condition=="Missing",NA)) 
    

year3Dat<-  
  tibble(FID=rep(fidList,each=540),
         Plot=rep(1:15,each=36,length.out=n.row),
         Row=rep(1:6,each=6,length.out=n.row),
         Column=rep(c(1:6,6:1),length.out=n.row),
         Date=rep(mdy("11-13-2021"),length.out=n.row),
         Species=rep(sppList,each=36*3,length.out=n.row),
         Seedlot=rep(seedLot,each=36,length.out=n.row),
         TreeID=rep(1:36,length.out=n.row),
         Height=runif(n.row,min=18,max=60),
         Diameter=runif(n.row,min=8,max=25),
         Condition=sample(condList,size=n.row, replace = TRUE, prob = c(75,12,5,3,4,5)),
         Dmg.Agent=NA,
         Dmg.Severity=NA,
         Comments=NA) %>% 
  mutate(Height=replace(Height,Condition=="Missing",NA)) %>% 
  mutate(Diameter=replace(Diameter,Condition=="Missing",NA))  
  
     

year5Dat<-  
  tibble(FID=rep(fidList,each=540),
         Plot=rep(1:15,each=36,length.out=n.row),
         Row=rep(1:6,each=6,length.out=n.row),
         Column=rep(c(1:6,6:1),length.out=n.row),
         Date=rep(mdy("11-13-2021"),length.out=n.row),
         Species=rep(sppList,each=36*3,length.out=n.row),
         Seedlot=rep(seedLot,each=36,length.out=n.row),
         TreeID=rep(1:36,length.out=n.row),
         Height=runif(n.row,min=18,max=90),
         Diameter=runif(n.row,min=8,max=67),
         Condition=sample(condList,size=n.row, replace = TRUE, prob = c(70,15,5,4,5,6)),
         Dmg.Agent=NA,
         Dmg.Severity=NA,
         Comments=NA) %>% 
  mutate(Height=replace(Height,Condition=="Missing",NA)) %>% 
  mutate(Diameter=replace(Diameter,Condition=="Missing",NA))                       

  # put it all together

fakeData<- rbind(year1Dat,year3Dat,year5Dat)
save(fakeData,file=here::here("data","fakeData","fakeData.RData"))
