/*
 Copyright (C) 1997, Alexander Pukhov 
*/

#include "chep_crt.h"
#include "files.h"
#include "plot.h"
#include <math.h>
#include "../../include/version.h"

/*
void  plot_Nar( char*  title, double xMin, double xMax, char*xName,  int dim, 
               int N, double **f,double**ff,char**Y)
*/

int main(int argc,char** argv)
{   
  char   xName[60];   
  char*yName=NULL; 
  char*buff=NULL,*procName=NULL;
  int bLen=0;
  double xMin,xMax;
  int xDim=1;
  double yMin,yMax;
  int yDim=1;
  int ptype=-1; 
  double *f=NULL, *df=NULL;
  FILE*F;
  
  int i, n;
  char icon_name[STRSIZ];
 
  blind=0;
 
  if(argc !=2) 
  {  printf("This function needs one argument: name of file which contains plot table\n");
     return 1;
  }
  F=fopen(argv[1],"r");
  if(!F)
  { printf("Can not open file '%s'\n",argv[1]);
    return 2;
  }
           
  strcpy(pathtocalchep,argv[0]);
  n = strlen(pathtocalchep)-1;
  while (n>=0 &&  pathtocalchep[n] != f_slash) n--;
  pathtocalchep[n-3]=0;
  sprintf(pathtohelp,"%shelp%c",pathtocalchep,f_slash);
 
  for(;;)
  { char word[40];
    long p1=ftell(F);
    long p2;
    fscanf(F,"%*[^\n]%*c");
    p2=ftell(F); 
    if(p2==EOF) break;
    if(p2-p1+1 > bLen) 
    { bLen=p2-p1+1;
      buff=realloc(buff, bLen);
    }
    fseek(F,p1,SEEK_SET);
    fscanf(F,"%[^\n]%*c",buff);  
    if(buff[0]!='#') {fseek(F,p1,SEEK_SET);  break;}
    if(1==sscanf(buff+1,"%s",word))
    {      if(strcmp(word,"type")==0)   sscanf(buff+1,"%*s %d",&ptype);    
      else if(strcmp(word,"xMin")==0)   sscanf(buff+1,"%*s %lf",&xMin);  
      else if(strcmp(word,"xMax")==0)   sscanf(buff+1,"%*s %lf",&xMax);  
      else if(strcmp(word,"yMin")==0)   sscanf(buff+1,"%*s %lf",&yMin);  
      else if(strcmp(word,"yMax")==0)   sscanf(buff+1,"%*s %lf",&yMax);  
      else if(strcmp(word,"xDim")==0)   sscanf(buff+1,"%*s %d",&xDim);  
      else if(strcmp(word,"yDim")==0)   sscanf(buff+1,"%*s %d",&yDim);    
      else if(strcmp(word,"title")==0)  
      { for(i=strlen(buff);buff[i-1]==' '; i--) buff[i-1]=0;
        procName=malloc(strlen(buff));
        if(1!=sscanf(buff+1,"%*s %[^\n]",procName)) procName[0]=0;;      
      }
      else if(strcmp(word,"xName")==0) 
      { for(i=strlen(buff);buff[i-1]==' '; i--) buff[i-1]=0;
        sscanf(buff+1,"%*s %[^\n]",xName);  
      }   
      else if(strcmp(word,"yName")==0) 
      { for(i=strlen(buff);buff[i-1]==' '; i--) buff[i-1]=0;
        yName=malloc(strlen(buff));    
        if(1!=sscanf(buff+1,"%*s %[^\n]",yName)) yName[0]=0;  
      }
    } else break;
  }  
  
  if(bLen<100) buff=realloc(buff,100); 
  if(!procName)  procName=" ";
  
  if(yDim==1)
  {
    char *ch=yName;
    int N=0;
    
    for(ch=yName; ch=strstr(ch,"{c}"); ch+=3) N++;
    for(ch=yName; ch=strstr(ch,"{h}"); ch+=3) N++; 
    if(N)
    {  double **fn=malloc(N*sizeof(double*));
       double **dn=malloc(N*sizeof(double*));
       char**Y    =malloc(N*sizeof(char*)); 
       for(n=0,ch=yName;n<N;n++)
       {  char*chc=strstr(ch,"{c}");
          char*chh=strstr(ch,"{h}");  
          Y[n]=malloc(50);
          fn[n]=malloc(xDim*sizeof(double));
          if(chc && (  chc<chh || !chh )) 
          { chc[0]=0;
            sscanf(ch,"%s",Y[n]);
            dn[n]=NULL;
            ch=chc+3;
          } else
          { chh[0]=0;
            sscanf(ch,"%s",Y[n]);
            dn[n]=malloc(xDim*sizeof(double));
            ch=chh+3; 
          }
          printf(" Y[%d]= %s f=%p d=%p\n",n,Y[n],fn[n],dn[n]);
       }
       for(i=0;i<xDim;i++) for(n=0;n<N;n++)
       { fscanf(F,"%lf",fn[n]+i); 
         if( !isfinite(fn[n][i]) ){ printf(" NAN in table \n"); return 2;}
         if(dn[n]) 
         { fscanf(F,"%lf",dn[n]+i); 
           if( !isfinite(dn[n][i]) ){ printf(" NAN in table \n"); return 2;}
         }
       }
       fclose(F);     
       sprintf(icon_name,"%s/include/icon",pathtocalchep);
       start1(VERSION_ ,icon_name,"calchep.ini;../calchep.ini",NULL);
       clearTypeAhead();
       plot_Nar(procName,xMin,xMax,xName,xDim,N,fn,dn,Y);
       finish();
       return 0; 
    }
    return 1;
  }
  
  f=(double*)malloc(xDim*yDim*sizeof(double));   
  if(ptype)
  { 
    df=(double*)malloc(xDim*yDim*sizeof(double)); 
    sscanf(buff,"%lf  %lf",f,df);  
    for(i=1;i<xDim*yDim;i++) fscanf(F,"%lf  %lf",f+i,df+i);
    for(i=1;i<xDim*yDim;i++) if( !isfinite(f[i])|| !isfinite(df[i]) )
       { printf(" NAN in table %s\n",procName); return 0;}
  }
  else 
  { 
    sscanf(buff,"%lf",f);
    for(i=1;i<xDim*yDim;i++) fscanf(F,"%lf",f+i);
    for(i=1;i<xDim*yDim;i++) if( !isfinite(f[i])){ printf(" NAN in table %s\n",procName); return 0;} 
  }             
  sprintf(icon_name,"%s/include/icon",pathtocalchep);
  start1(VERSION_ ,icon_name,"calchep.ini;../calchep.ini",NULL);  
  clearTypeAhead();
  if(ptype==2) plot_2D(xMin,xMax,xDim,yMin,yMax,yDim,f,df,procName,xName,yName);
  else 
  {
     plot_1(xMin,xMax,xDim,f,df,procName, xName, yName);
  }
  fclose(F);
  finish();
  return 0;
}
