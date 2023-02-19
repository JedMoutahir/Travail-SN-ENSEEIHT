import java.rmi.*;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;
import java.util.ServiceConfigurationError;
import java.lang.reflect.InvocationTargetException;
import java.net.*;

public class Client extends UnicastRemoteObject implements Client_itf {

	private static HashMap<Integer, SharedObject> mapObjects = new HashMap<Integer, SharedObject>();
	private static Server_itf server;
	private static Client client;
	
	public Client() throws RemoteException {
		super();
	}


///////////////////////////////////////////////////
//         Interface to be used by applications
///////////////////////////////////////////////////

	public static void init() {
		try {
			server = (Server_itf) Naming.lookup(Server.URL);
			client = new Client();
		} catch (MalformedURLException | RemoteException | NotBoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public static SharedObject lookup(String name) {
		try {
			int id = server.lookup(name);
			//System.out.println("id in client : " + id);
			if(id == -1) return null;
			SharedObject so = mapObjects.get(id);
			
			if (so == null) {
				so = new SharedObject(null, id, server);
			}
			mapObjects.put(id, so);
			//System.out.println("so in map in client : " + mapObjects.get(id));
			return so;
		} catch (RemoteException | IllegalArgumentException | SecurityException e) {
			e.printStackTrace();
			return null;
		}
	}		

	public static void register(String name, SharedObject_itf so) {
		Server_itf serv = null;
		try {
			serv = (Server_itf) Naming.lookup(Server.URL);
		} catch (MalformedURLException | RemoteException | NotBoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		SharedObject s = (SharedObject) so;
		try {
			serv.register(name, s.id);
		} catch (RemoteException e) {
			e.printStackTrace();
			throw new ServiceConfigurationError("Echec lors de l'enregistrement de l'objet");
		}	
	}

	public static SharedObject create(Object o) {
		Server_itf serv = null;
		try {
			serv = (Server_itf) Naming.lookup(Server.URL);
		} catch (MalformedURLException | RemoteException | NotBoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			int id = serv.create(o);
			SharedObject so = new SharedObject(o, id, serv);
			mapObjects.put(id, so);
			return so;
		}  catch (RemoteException e) {
			e.printStackTrace();
			throw new ServiceConfigurationError("Echec lors de la creation de l'objet");
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("Returned a null so");
		return null;
	}
	
/////////////////////////////////////////////////////////////
//    Interface to be used by the consistency protocol
////////////////////////////////////////////////////////////

	public static Object lock_read(int id) {
		try {
			Server_itf serv = null;
			try {
				serv = (Server_itf) Naming.lookup(Server.URL);
			} catch (MalformedURLException | RemoteException | NotBoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			Object returnObj = serv.lock_read(id, new Client());
			//if(returnObj == null) System.out.println("Returned a null obj in lock_read");
			return returnObj;
		}  catch (RemoteException e) {
			e.printStackTrace();
			throw new ServiceConfigurationError("Echec du lock_read Client");
		} 
	}

	public static Object lock_write (int id) {
		try {
			Server_itf serv = null;
			try {
				serv = (Server_itf) Naming.lookup(Server.URL);
			} catch (MalformedURLException | RemoteException | NotBoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			Object returnObj = serv.lock_write(id, new Client());
			//if(returnObj == null) System.out.println("Returned a null obj in lock_write");
			return returnObj;
		}  catch (RemoteException e) {
			System.out.println("id : " + id);
			e.printStackTrace();
			throw new ServiceConfigurationError("Echec du lock_write Client");
		} 
	}

	public Object reduce_lock(int id) throws java.rmi.RemoteException {
		SharedObject so = mapObjects.get(id);
		return so.reduce_lock();
	}

	public void invalidate_reader(int id) throws java.rmi.RemoteException {
		SharedObject so = mapObjects.get(id);
		System.out.println("id in invalidate_reader in Client : " + id + " ; so : " + so + " ; taille mapObject : " + mapObjects.size());
		so.invalidate_reader();
	}

	public Object invalidate_writer(int id) throws java.rmi.RemoteException {
		SharedObject so = mapObjects.get(id);
		System.out.println("obj in invalidate_writer in client : " + so);
		return so.invalidate_writer();
	}

	public static void clientValidation(int id) {
		Server_itf serv = null;
		try {
			serv = (Server_itf) Naming.lookup(Server.URL);
		} catch (MalformedURLException | RemoteException | NotBoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		try {
			serv.clientValidation(id);
		} catch (RemoteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public static void abonner(int id) {
		// TODO Auto-generated method stub
		Server_itf serv = null;
		try {
			serv = (Server_itf) Naming.lookup(Server.URL);
			serv.abonner(client, id);
		} catch (MalformedURLException | RemoteException | NotBoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public static void desabonner(int id) {
		// TODO Auto-generated method stub
		Server_itf serv = null;
		try {
			serv = (Server_itf) Naming.lookup(Server.URL);
			serv.desabonner(client, id);
		} catch (MalformedURLException | RemoteException | NotBoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void callBack(int id) throws java.rmi.RemoteException {
		SharedObject so = mapObjects.get(id);
		so.callback();;
	}
}
