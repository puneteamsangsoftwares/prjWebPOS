package com.sanguine.util;

import java.net.DatagramPacket;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Objects;

import org.json.simple.JSONObject;

import com.sanguine.controller.clsUserController;
 
/**
 * This program demonstrates how to implement a UDP server program.
 * @author www.codejava.net
 */
 
public class clsSocketServer extends Thread{
   
   // int port = 5001;
    JSONObject jsonOb;
    String merchant_ref_id="";
//	
//	  public clsSocketServer(int port) throws SocketException {
//		  socket = 
//		  }
	  
 
	  public void start(JSONObject jsonOb) {
		  this.jsonOb=jsonOb;
		  try {
			
			  LinkedHashMap jObOrder=  (LinkedHashMap) jsonOb.get("order");
			  LinkedHashMap jObStore=(LinkedHashMap)jObOrder.get("store");
			  merchant_ref_id = (String) jObStore.get("merchant_ref_id");
//			 / run();
			  //start();
		  }catch(Exception e) {
			  e.printStackTrace();
		  }
		  
	  }
	  public void run() {
		  
	    	while (true) {
	 
	    		try {
	    			
	    			byte[] clientBuff=new byte[512];
	        		DatagramPacket request = new DatagramPacket(clientBuff,clientBuff.length);
	        		clsUserController.socket.receive(request);
	     
	                
	                String clientCode = new String(clientBuff, 0, request.getLength());
	               // String clientCode=clientBuff.toString();
	                
	                System.out.println("clientCode -"+ clientCode);
	                byte[] buffer =new byte[256];
	                InetAddress clientAddress = request.getAddress();
 	                int clientPort = request.getPort();
 	     
 	                if(!(merchant_ref_id==null||merchant_ref_id.isEmpty())) {
 	
 	                	buffer = merchant_ref_id.getBytes();//jsonOb.toString().getBytes();
 	            	     
 	                   DatagramPacket response = new DatagramPacket(buffer, buffer.length, clientAddress, clientPort);
 	                  clsUserController.socket.send(response);
 	    
 		                if(merchant_ref_id !=null && !merchant_ref_id.isEmpty() && merchant_ref_id.contains(clientCode)) {
 		 	                 break;
 		                }
 		
 	                }
 	                
 	                    
               	    			
	    		}catch(Exception e) {
	    			e.printStackTrace();
	    		}
	    		//i++;
	            
	    	}

	  }

	/*
	 * public static void broadcast( String broadcastMessage, InetAddress address)
	 * throws IOException { socket = new DatagramSocket();
	 * socket.setBroadcast(true);
	 * 
	 * byte[] buffer = broadcastMessage.getBytes();
	 * 
	 * DatagramPacket packet = new DatagramPacket(buffer, buffer.length, address,
	 * 4445); socket.send(packet); socket.close(); }
	 */  
	/*
	 * public List<InetAddress> listAllBroadcastAddresses() throws SocketException {
	 * List<InetAddress> broadcastList = new ArrayList<>();
	 * Enumeration<NetworkInterface> interfaces =
	 * NetworkInterface.getNetworkInterfaces(); while (interfaces.hasMoreElements())
	 * { NetworkInterface networkInterface = interfaces.nextElement();
	 * 
	 * if (networkInterface.isLoopback() || !networkInterface.isUp()) { continue; }
	 * 
	 * networkInterface.getInterfaceAddresses().stream() .map(a -> a.getBroadcast())
	 * .filter(Objects::nonNull) .forEach(broadcastList::add); } return
	 * broadcastList; }
	 * 
	 */
}