//+------------------------------------------------------------------+
//|                                                     Chartmax.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#import "shell32.dll"
int ShellExecuteW(int hwnd,string Operation,string File,string Parameters,string Directory,int ShowCmd);
#import 
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
string Sym,file;
int OnInit()
  {  
  
  Sym=StringSubstr(Symbol(),0,6)+"_S.bat";
                   file="c:\\"+Sym;
  
//int filehandle = FileOpen(Symbol(),FILE_WRITE|FILE_TXT);
// FileWriteString(filehandle, "55");  
// FileClose(filehandle); 
//ShellExecuteW(NULL,"open",file,NULL,NULL,1);

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
//+------------------------------------------------------------------+
 ;

 void OnTick()
  { 
  //ShellExecuteW(NULL,"open","c:\\55.bat",NULL,NULL,1);
  
  
  // if(FileIsExist("2.70.txt")){
  // Comment("2.70");
  // }
  // else{Comment("no");
  // }
  // FileDelete("2.70.txt");
  
 // Sym=Symbol()+"S";
//Sym=StringSubstr(Symbol(),0,6)+"_S";
//if(FileIsExist(Sym)){
 //Comment(Sym);
 //}else{Comment("no");}
 
  // FileDelete(Sym);
  
  }
//+------------------------------------------------------------------+

