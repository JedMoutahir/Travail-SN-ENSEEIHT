import java.net.InetAddress;
import java.net.MalformedURLException;
import java.net.UnknownHostException;
import java.rmi.Naming;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;
import java.util.Map;

public class CarnetImpl extends UnicastRemoteObject implements Carnet {

	int port;
	
	HashMap<String, RFiche> carnet = new HashMap<String, RFiche>();

	String nextURL;
	
	public CarnetImpl(int port, int num) throws RemoteException {
		// TODO Auto-generated constructor stub
		this.port = port;
		this.nextURL = "//localhost:" + port +"/carnet" + num ;
	}

	@Override
	public void Ajouter(SFiche sf) throws RemoteException {
		// TODO Auto-generated method stub
		carnet.put(sf.getNom(), new RFicheImpl(sf.getNom(), sf.getEmail()));
	}

	@Override
	public RFiche Consulter(String n, boolean forward) throws RemoteException {
		// TODO Auto-generated method stub
		RFiche rf = carnet.get(n);
		if(rf != null) return rf;
		if(forward) {
			//forward
			try {
				return ((Carnet) Naming.lookup(this.nextURL)).Consulter(n, false);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return null;
	}

	public static void main(String args[]) {
		int port = 4000;
		
		try {
			LocateRegistry.createRegistry(port);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		try {
			String URL1 = "//localhost:" + port +"/carnet1" ;

			Carnet carnet1 = new CarnetImpl(port, 2);

			String URL2 = "//localhost:" + port +"/carnet2" ;

			Carnet carnet2 = new CarnetImpl(port, 1);
			System.out.println(URL1);
			Naming.rebind(URL1, carnet1);
			Naming.rebind(URL2, carnet2);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}


}
