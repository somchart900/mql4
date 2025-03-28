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
   ObjectsDeleteAll();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
extern double Lots =0.1;
extern double LotsXponent =1;
double LotsD =Lots;
extern int TP =200;
extern int SL =0;
extern int Grid_Minimun =200;
extern int MagicNumber =1001;
extern int Slippage =10;
extern bool Enable_TrailingStop =True;
extern int TralingStart_After_Profit =500;
extern int TralingStep =200;
int ticket,BuyOpen,SellOpen; 
double markb,BuyOpenProfit,SellOpenProfit,bb,TC,marks;
double B=AccountBalance(); 
extern string extoken = "6Cpi4vZIHB6xYh9RnCHpgmIzmSe4J5G8hps49dBs1kB" ;
extern bool Notify =false;
extern double Parbolic_Step =0.01;
extern double Parbolic_Maximum =0.06;
input ENUM_TIMEFRAMES P_Period =PERIOD_H1;

//----------------------------------------------------------------------------------------------------------
void Openbuy(){
  ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,Ask+TP*Point,"",MagicNumber,0,clrNONE);
}
//---------------------------
void OpenSell(){
  ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,Bid-TP*Point,"",MagicNumber,0,clrNONE);
}
//-----------------------------
  void CloseAll(){
   bool res;
      for(int i=OrdersTotal()-1;i>=0;i--){
      res = OrderSelect(i,SELECT_BY_POS);
          if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){    
           res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
           } 
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){    
           res = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrNONE);
           } 
      }
 
 }

 //-------------------------------------------------
 void GetStat(){ SellOpen=0; BuyOpen=0; BuyOpenProfit=0; SellOpenProfit=0;
 bool res;
     for(int i = 0;i < OrdersTotal();i++){  
     res = OrderSelect(i,SELECT_BY_POS);
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL){SellOpen++;
           Lots = OrderLots();marks=OrderOpenPrice(); SellOpenProfit+=OrderProfit()+OrderSwap();
           }
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY){BuyOpen++;
           Lots = OrderLots(); markb=OrderOpenPrice(); BuyOpenProfit+=OrderProfit()+OrderSwap();
           }
    
      }   
}   

//--------------------------------------------------------------------------------------------------  
 //-----------------------------
double SAR,SAR1;
void GetIndy(){
  SAR1=iSAR(Symbol(),PERIOD_H1,Parbolic_Step,Parbolic_Maximum,0); 
  SAR=iSAR(Symbol(),PERIOD_D1,Parbolic_Step,Parbolic_Maximum,0); 

}
//-------------------------------------------------------------------------------------------------- 


void Treding(){ GetStat();GetIndy();
     if(BuyOpen==0 && SellOpen==0){TC=AccountBalance();}
     if(SAR < Open[0] && SAR1 < Open[0]){if(BuyOpen==0){Openbuy();}
         if(BuyOpen>=1){
            if(Ask < markb-Grid_Minimun*Point){ Lots=Lots*LotsXponent;Openbuy();}
            
         }
     }
     if(SAR > Open[0] && SAR1 > Open[0]){if(SellOpen==0){OpenSell();}
         if(SellOpen>=1){
            if(Bid > marks+Grid_Minimun*Point){Lots=Lots*LotsXponent;OpenSell();}
         }
     }  
       
   if(AccountEquity()>TC+0.4){CloseAll();}        
                               
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
ObjectSet("0", OBJPROP_XDISTANCE, 130);
ObjectSet("0", OBJPROP_YDISTANCE, 20);
ObjectSet("0", OBJPROP_XSIZE, 220);
ObjectSet("0", OBJPROP_YSIZE, 300);
ObjectSet("0", OBJPROP_BORDER_COLOR,clrMediumBlue);
ObjectSet("0", OBJPROP_BGCOLOR,clrBlack);
ObjectSetText("0","", 20, NULL, clrNONE);

ObjectCreate("1", OBJ_LABEL, 0, 0, 0);
ObjectSetText("1","Grid Systems", 20, NULL, clrMagenta);
ObjectSet("1", OBJPROP_XDISTANCE, 150);
ObjectSet("1", OBJPROP_YDISTANCE, 20);

ObjectCreate("2", OBJ_LABEL, 0, 0, 0);
ObjectSetText("2",StringFormat("BuyOpen = %G",BuyOpen), 15, NULL, clrBisque);
ObjectSet("2", OBJPROP_XDISTANCE,150);
ObjectSet("2", OBJPROP_YDISTANCE, 70);

ObjectCreate("3", OBJ_LABEL, 0, 0, 0);
ObjectSetText("3",StringFormat("SellOpen = %G",SellOpen), 15,NULL, clrDarkGray);
ObjectSet("3", OBJPROP_XDISTANCE, 150);
ObjectSet("3", OBJPROP_YDISTANCE, 100);

ObjectCreate("4", OBJ_LABEL, 0, 0, 0);
ObjectSetText("4",StringFormat("Equity = %G",AccountEquity()), 15,NULL, clrSienna);
ObjectSet("4", OBJPROP_XDISTANCE, 150);
ObjectSet("4", OBJPROP_YDISTANCE, 130);

ObjectCreate("5", OBJ_LABEL, 0, 0, 0);
ObjectSetText("5",StringFormat("Balance = %G",AccountBalance()), 15,NULL, clrAqua);
ObjectSet("5", OBJPROP_XDISTANCE, 150);
ObjectSet("5", OBJPROP_YDISTANCE, 160);

ObjectCreate("6", OBJ_LABEL, 0, 0, 0);
ObjectSetText("6",StringFormat("Price Target=%G",TC), 15,NULL, clrGreenYellow);
ObjectSet("6", OBJPROP_XDISTANCE, 150);
ObjectSet("6", OBJPROP_YDISTANCE, 190);



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
void OnTick(){
eng();
if(Enable_TrailingStop)TrailingStop(); 
//Treding();
if(Notify)sendline();
}
//----------------------------------------------------------------------------------------------------------

