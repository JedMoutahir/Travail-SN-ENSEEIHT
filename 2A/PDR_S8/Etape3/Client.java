import java.net.MalformedURLException;
import java.rmi.Naming;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public class Client extends UnicastRemoteObject implements Client_itf {
	static String address = "//localhost:5555/Server";
	
	static Client_itf me;
	
	protected Client() throws RemoteException {
		super();
		// TODO Auto-generated constructor stub
	}
	private static final long serialVersionUID = 1L;
	
	public static void init() {
		// Récupération de l'objet serveur à partir de son adresse
		try {
			me = new Client();
			Server_itf server = (Server_itf) Naming.lookup("//localhost:5555/Server");
			server.addClient(me);
		} catch (MalformedURLException | RemoteException | NotBoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static SharedObject publish(String name, Object content, boolean reset) {
		// Récupération de l'objet serveur à partir de son adresse
		SharedObject so = null;
		try {
			Server_itf server = (Server_itf) Naming.lookup("//localhost:5555/Server");
			int version = server.publish(name, content, reset);
			so = new SharedObject(content, version);
		} catch (MalformedURLException | RemoteException | NotBoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return so;
	}

	@Override
	public void initialiser_un_objet(int idObjet, Object valeur) throws RemoteException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void enquete(int idObjet, Rappel_lec cbl) throws RemoteException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void mise_a_jour(int idObjet, int version, Object valeur, Rappel_ecr cbr) throws RemoteException {
		// TODO Auto-generated method stub
		
	}

}
