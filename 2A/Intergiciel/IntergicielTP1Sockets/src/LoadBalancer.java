import java.util.Random;
import java.io.*;
import java.net.*;

public class LoadBalancer extends Thread {
	static String hosts[] = {"localhost", "localhost"};
	static int ports[] = {8081,8082};
	static int nbHosts = 2;
	static Random rand = new Random();
	Socket sClient;
	public LoadBalancer(Socket clientSocket) {
		sClient = clientSocket;
	}

	@Override
	public void run() {
		try {
			int serverChosen = rand.nextInt(hosts.length);

			Socket sWS = new Socket (hosts[serverChosen], ports[serverChosen]);

			InputStream isWS = sWS.getInputStream();
			InputStream isClient = sClient.getInputStream();

			OutputStream osWS = sWS.getOutputStream();
			OutputStream osClient = sClient.getOutputStream();

			byte[] buffer = new byte[10000000];

			int byteRead = isClient.read(buffer);
			
			osWS.write(buffer, 0, byteRead);

			byteRead = isWS.read(buffer);

			osClient.write(buffer, 0, byteRead);
			
			sClient.close();
			sWS.close();
			
		} catch (Exception e) {
			System.err.println(e);
		}
	}

	public static void main (String args []) {
		try {
			ServerSocket ss;

			int port = 8080;

			ss = new ServerSocket(port);
			
			System.out.println("Server ready ...");

			while (true) {
				LoadBalancer lb = new LoadBalancer(ss.accept());
				lb.start();
			}
		} catch (Exception e) {
			System.out.println("An error has occurred ...");
			e.printStackTrace();
		}
	}
}

