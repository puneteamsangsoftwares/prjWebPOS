package com.sanguine.util;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;

public class clsBroadCastingClient {
private static DatagramSocket socket = null;

	public static void main(String[] args) throws IOException
	{
		broadcast("Hello", InetAddress.getByName("127.0.0.1"));
	}

	public static void broadcast( String broadcastMessage, InetAddress address) throws IOException {
	    socket = new DatagramSocket();
	    socket.setBroadcast(true);
	
	    byte[] buffer = broadcastMessage.getBytes();
	
	    DatagramPacket packet = new DatagramPacket(buffer, buffer.length, address, 4445);
	    socket.send(packet);
	    socket.close();
	}
}