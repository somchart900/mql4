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
//if(Period() != 43200){ChartSetSymbolPeriod(ChartID(),_Symbol,PERIOD_MN1);}
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
extern double LotsXponent =2;
double LotsD =Lots;
int SL =80000;
extern int Grid_Minimun =300;
extern double Close_Minimun_US =0;
extern int MagicNumber =1000;
extern int Slippage =1000;
extern bool Enable_TrailingStop =True;
extern int TralingStart_After_Profit =1500;
extern int TralingStep =200;
extern double Parbolic_Step =0.02;
extern double Parbolic_Maximum =0.2;
int ticket,BuyOpen,SellOpen; 
double last,bath,mark,SellOpenProfit,BuyOpenProfit,lastbar,bb,sp;
double B=AccountBalance();
input ENUM_TIMEFRAMES P_Period =PERIOD_H1;
extern string extoken = "6Cpi4vZIHB6xYh9RnCHpgmIzmSe4J5G8hps49dBs1kB" ;
extern bool Notify =false;
//----------------------------------------------------------------------------------------------------------
void Openbuy(){
  ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,"Buy",MagicNumber,0,clrNONE);
}
//---------------------------
void OpenSell(){
  ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,Bid+SL*Point,0,"Sell",MagicNumber,0,clrNONE);
}
//-----------------------------

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
void  CloseProfitSell(){  
  bool res;
   for(int i=OrdersTotal()-1;i>=0;i--){
   res = OrderSelect(i,SELECT_BY_POS);
           
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){ if(OrderProfit()>Close_Minimun_US){
           res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
           } }
          
    
   }
}  
//-----------------------------------------------------------------------------------------------------  
void  CloseProfitBuy(){  
  bool res;
   for(int i=OrdersTotal()-1;i>=0;i--){
   res = OrderSelect(i,SELECT_BY_POS);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){ if(OrderProfit()>Close_Minimun_US){
           res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
           }}  
   }
} 
//-------------------------------------------------------------------------------------------------- 

 void GetStatBuy(){ BuyOpen=0; BuyOpenProfit=0;
 bool res;
     for(int i = 0;i < OrdersTotal();i++){  
     res = OrderSelect(i,SELECT_BY_POS);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){BuyOpen++;BuyOpenProfit+=OrderProfit()+OrderSwap();
           Lots = OrderLots(); mark=OrderOpenPrice();if(Lots>=LotsD*8){LotsXponent =1.5;}
           } 
      }   
}   
 //-----------------------------
 //-------------------------------------------------------------------------------------------------- 

 void GetStatSell(){SellOpen=0; SellOpenProfit=0;
 bool res;
     for(int i = 0;i < OrdersTotal();i++){  
     res = OrderSelect(i,SELECT_BY_POS);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){SellOpen++; SellOpenProfit+=OrderProfit()+OrderSwap();
           Lots = OrderLots();mark=OrderOpenPrice();if(Lots>=LotsD*8){LotsXponent =1.5;}
           }
      }   
}   
 //-----------------------------
double SAR,SAR1;
void GetIndy(){
  SAR1=iSAR(Symbol(),P_Period,Parbolic_Step,Parbolic_Maximum,1);
  SAR=iSAR(Symbol(),P_Period,Parbolic_Step,Parbolic_Maximum,0); 
}
//--------------------------------------------------------------------------------------------------  
void Treding(){ GetIndy(); 
                if(SAR1 < Open[1] && SAR > Open[0]){ 
                sp=SAR-SAR1;
                sp=MathRound(sp/Point);
                sp=MathRound(sp/1.5);
                }
                 if(SAR1 > Open[1] && SAR < Open[0]){
                sp=SAR1-SAR;
                sp=MathRound(sp/Point);
                sp=MathRound(sp/1.5);
                 }

} 
//----------------------------------------------------------------------------------------------------------  
void TrailingStop(){ bool res;
  for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
          if(OrderSymbol()==Symbol() && OrderMagicNumber() == MagicNumber){
                 if(OrderType() == OP_BUY){
                     if(Bid-OrderOpenPrice() > TralingStart_After_Profit*Point){                 
                         if(OrderStopLoss() < Bid-TralingStep*Point){ 
                          res = OrderModify(OrderTicket(),OrderOpenPrice(),Bid-TralingStep*Point,OrderTakeProfit(),0,0);
                         }
                     }
                     
                 }
                 if(OrderType() == OP_SELL){
                    if(OrderOpenPrice()-Ask > TralingStart_After_Profit*Point){
                        if(OrderStopLoss() > Ask+TralingStep*Point){
                           res = OrderModify(OrderTicket(),OrderOpenPrice(),Ask+TralingStep*Point,OrderTakeProfit(),0,0);                        
                        }
                    }   
                 }
                          
              }       
      }
   } 
}

//-----------------------------------------------------------------------------------------------------------------------------         
void eng(){
ObjectCreate("0", OBJ_BUTTON, 0, 0, 0);
ObjectSet("0", OBJPROP_XDISTANCE, 2);
ObjectSet("0", OBJPROP_YDISTANCE, 2);
ObjectSet("0", OBJPROP_XSIZE, 220);
ObjectSet("0", OBJPROP_YSIZE, 300);
ObjectSet("0", OBJPROP_BORDER_COLOR,clrMediumBlue);
ObjectSet("0", OBJPROP_BGCOLOR,clrBlack);
ObjectSetText("0","", 20, NULL, clrNONE);

ObjectCreate("1", OBJ_LABEL, 0, 0, 0);
ObjectSetText("1","Profit System", 20, NULL, clrGray);
ObjectSet("1", OBJPROP_XDISTANCE, 20);
ObjectSet("1", OBJPROP_YDISTANCE, 20);

ObjectCreate("2", OBJ_LABEL, 0, 0, 0);
ObjectSetText("2",StringFormat("BuyOpen = %G",BuyOpen), 15, NULL, clrGray);
ObjectSet("2", OBJPROP_XDISTANCE, 20);
ObjectSet("2", OBJPROP_YDISTANCE, 70);

ObjectCreate("3", OBJ_LABEL, 0, 0, 0);
ObjectSetText("3",StringFormat("BuyProfit = %G",BuyOpenProfit), 15,NULL, clrGray);
ObjectSet("3", OBJPROP_XDISTANCE, 20);
ObjectSet("3", OBJPROP_YDISTANCE, 100);

ObjectCreate("4", OBJ_LABEL, 0, 0, 0);
ObjectSetText("4",StringFormat("SellOpen = %G",SellOpen), 15,NULL, clrGray);
ObjectSet("4", OBJPROP_XDISTANCE, 20);
ObjectSet("4", OBJPROP_YDISTANCE, 130);


ObjectCreate("5", OBJ_LABEL, 0, 0, 0);
ObjectSetText("5",StringFormat("SellProfit=%G",SellOpenProfit), 15,NULL, clrGray);
ObjectSet("5", OBJPROP_XDISTANCE, 20);
ObjectSet("5", OBJPROP_YDISTANCE, 160);

ObjectCreate("6", OBJ_LABEL, 0, 0, 0);
ObjectSetText("6",StringFormat("Equity = %G",AccountEquity()), 15,NULL, clrGray);
ObjectSet("6", OBJPROP_XDISTANCE, 20);
ObjectSet("6", OBJPROP_YDISTANCE, 190);

ObjectCreate("7", OBJ_LABEL, 0, 0, 0);
ObjectSetText("7",StringFormat("Balance = %G",sp), 15,NULL, clrGray);
ObjectSet("7", OBJPROP_XDISTANCE, 20);
ObjectSet("7", OBJPROP_YDISTANCE, 220);
}
//----------------------------------------------------------------------
void LineNotify(string token,string Massage){
 string headers;
 char post[], result[];

headers="Authorization: Bearer "+token+"\r\n";
 headers+="Content-Type: application/x-www-form-urlencoded\r\n";

ArrayResize(post,StringToCharArray("message="+Massage,post,0,WHOLE_ARRAY,CP_UTF8)-1);

int res = WebRequest("POST", "https://notify-api.line.me/api/notify", headers, 10000, post, result, headers);

Print("Status code: " , res, ", error: ", GetLastError());
 Print("Server response: ", CharArrayToString(result));
}
 
void sendline(){if(AccountBalance() > B){bb=AccountBalance()-B;B=AccountBalance(); LineNotify(extoken," โบรคเกอร์ "+AccountCompany()+" พอร์ท  "+IntegerToString(AccountNumber())+" บวก "+DoubleToString(bb,2)+" USC");}}  

void OnTick(){if(Period() != P_Period){ChartSetSymbolPeriod(ChartID(),_Symbol,P_Period);}
eng();
if(Enable_TrailingStop)TrailingStop(); 
if(Notify)sendline();
Treding();

}
//----------------------------------------------------------------------------------------------------------

