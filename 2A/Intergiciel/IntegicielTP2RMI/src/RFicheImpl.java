import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public class RFicheImpl extends UnicastRemoteObject implements RFiche {
	
	String nom, email;
	
	public RFicheImpl(String name, String mail) throws RemoteException{
		this.nom = name;
		this.email = mail;
	}
	
	@Override
	public String getNom() throws RemoteException {
		// TODO Auto-generated method stub
		return this.nom;
	}

	@Override
	public String getEmail() throws RemoteException {
		// TODO Auto-generated method stub
		return this.email;
	}

}
