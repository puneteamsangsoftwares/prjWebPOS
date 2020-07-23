package com.sanguine.util;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;  
class MyServer{  
public static void main(String args[])throws Exception
{  
	ServerSocket ss=new ServerSocket(5001);  
	Socket s=ss.accept();  
	DataInputStream din=new DataInputStream(s.getInputStream());  
	DataOutputStream dout=new DataOutputStream(s.getOutputStream());  
	BufferedReader br=new BufferedReader(new InputStreamReader(System.in));  
  
	dout.writeUTF("Hello clients............ ");
	String str="",str2="";  
	int i=0;
	while(!str.equals("stop")){
		
		Thread.sleep(3000);
		++i;
		
		//str=din.readUTF();  
		//System.out.println("client says: "+str);  
		//str2=br.readLine();
		dout.writeUTF(" vinayak" + i); 
		//dout.writeUTF(str2);  
		dout.flush();
	}  
	din.close();  
	s.close();  
	ss.close();  
	}
}  