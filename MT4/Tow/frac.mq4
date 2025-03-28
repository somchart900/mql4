//+------------------------------------------------------------------+
//|                                                    .mq4 |
//|                         |
//|                                          |
//+------------------------------------------------------------------+
#property copyright "."
#property link      "https://www.facebook.com/huaylungcafe"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  { 
 ObjectsDeleteAll();
 ChartSetInteger(ChartID(),CHART_SHOW_PERIOD_SEP,0,0);
 ChartSetInteger(ChartID(),CHART_FOREGROUND,0,0);
 ChartSetInteger(ChartID(),CHART_SHOW_GRID,0,0);
 ChartSetInteger(ChartID(),CHART_SHIFT,0,1);
 ChartSetInteger(ChartID(),CHART_AUTOSCROLL,0,1);
 ChartSetInteger(ChartID(),CHART_MODE,CHART_CANDLES,1);
 ChartSetInteger(ChartID(),CHART_COLOR_CANDLE_BEAR,clrRed);
 ChartSetInteger(ChartID(),CHART_COLOR_CANDLE_BULL,clrLime);
 ChartSetInteger(ChartID(),CHART_COLOR_CHART_DOWN,clrRed);
//---                                 
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
extern double Lots =0.10;
extern double TP= 2000;
extern double SL= 2000;
extern double LotsXponent =1.5;
double Start_Lots =Lots;
extern int MagicNumber =100;
extern int Slippage =10;
input int Allow_Spred=20;
int ticket,BuyOpen,SellOpen,lastbar;
double spd;


//----------------------------------------------------------------------------------------------------------
void OpenBuy(){ 
Lots=Start_Lots;
double pf=0;
bool res;
       for(int i = 0;i < OrdersHistoryTotal();i++){  
       res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber){ pf=OrderProfit();}                                                                      
        }  
        if(pf<0){ Lots =OrderLots()*LotsXponent;} 
  ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,Ask-SL*Point,Ask+TP*Point,"RAPID-FIRE",MagicNumber,0,clrNONE);
  lastbar=Bars;
}
//---------------------------
void OpenSell(){ 
Lots=Start_Lots;
bool res;
double pf=0;
       for(int i = 0;i < OrdersHistoryTotal();i++){  
       res = OrderSelect(i,SELECT_BY_POS,MODE_HISTORY);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber){ pf=OrderProfit();}                                                                      
        }  
        if(pf<0){ Lots =OrderLots()*LotsXponent;} 
  ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,Bid+SL*Point,Bid-TP*Point,"RAPID-FIRE",MagicNumber,0,clrNONE);
   lastbar=Bars;
}
//-----------------------------

 //-----------------------------
 void GetStatBuy(){ BuyOpen=0; 
 bool res;
     for(int i = 0;i < OrdersTotal();i++){  
     res = OrderSelect(i,SELECT_BY_POS);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){BuyOpen++;} 
      }   
}   
 //-----------------------------
 //-------------------------------------------------------------------------------------------------- 

 void GetStatSell(){SellOpen=0; 
 bool res;
     for(int i = 0;i < OrdersTotal();i++){  
     res = OrderSelect(i,SELECT_BY_POS);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){SellOpen++;}
      }   
}   
 //-----------------------------

double SAR0,Sel,Buy;
void GetIndy(){ 
 
 SAR0=iSAR(Symbol(),0,0.02,0.2,0);  
 Sel=iFractals(NULL,0,MODE_UPPER,2);
 Buy=iFractals(NULL,0,MODE_LOWER,2);
     spd = Ask-Bid;
     spd=MathRound(spd/Point);
}
//--------------------------------------------------------------------------------------------------  
void Treding(){ GetIndy();  GetStatSell(); GetStatBuy();
if(SellOpen==1){SELL_TP();}
if(BuyOpen==1){BUY_TP();}

     
           if(Open[1]>SAR0){CloseSell();
                  if(Buy > 0){Comment("UP"); 
                   if(lastbar!=Bars){
                             if(BuyOpen==0){if(spd <= Allow_Spred){OpenBuy();}}
                   }
            }         
     }
     
           if(Open[1]<SAR0){ CloseBuy();
                 if(Sel > 0){Comment("Down");
                   if(lastbar!=Bars){
                             if(SellOpen==0){if(spd <= Allow_Spred){OpenSell();}}
                   }
            }         
     }


}
//----------------------------------------------------------------------------------------------------------  
void BUY_TP(){ bool res;
  for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
          if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber ){
                 if(OrderType() == OP_BUY){ double TPB =OrderOpenPrice()+TP*Point; TPB=NormalizeDouble(TPB,Digits);
                    if(OrderTakeProfit() != TPB){                                      
                          res = OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-SL*Point,OrderOpenPrice()+TP*Point,0,0);                         
                     }
                 }           
          }                                    
      }       
   } 
}

//----------------------------------------------------------------------------------------------------------------------------- 

//----------------------------------------------------------------------------------------------------------  
void SELL_TP(){ bool res;
  for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
          if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber ){
                 if(OrderType() == OP_SELL){ double TPS =OrderOpenPrice()-TP*Point; TPS=NormalizeDouble(TPS,Digits);
                    if(OrderTakeProfit() != TPS){                                      
                          res = OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+SL*Point,OrderOpenPrice()-TP*Point,0,0);                         
                     }
                 }           
          }                                    
      }       
   } 
}

//----------------------------------------------------------------------------------------------------------------------------- 



void OnTick(){ 
Treding();

} 
//----------------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------- 
void  CloseSell(){ 
  bool res;
      for(int i=OrdersTotal()-1;i>=0;i--){
      res = OrderSelect(i,SELECT_BY_POS);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){
           res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
           }
          
      }
}  
void  CloseBuy(){ 
  bool res;
      for(int i=OrdersTotal()-1;i>=0;i--){
      res = OrderSelect(i,SELECT_BY_POS);
          if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){
           res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
           } 
      }
}  

//----------------------------------------------------------------------------------------------------- 