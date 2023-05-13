import java.io.*;
import java.util.concurrent.Semaphore;
import java.util.Set;
import java.rmi.RemoteException;


public class SharedObject implements Serializable, SharedObject_itf {

    private static final long serialVersionUID = 1L;
    private int version;
    private int id;
    public Object obj;

    public SharedObject(int idObj, Object valeur) {
		// TODO Auto-generated constructor stub
    	this.id = idObj;
    	this.obj = valeur;
	}

	public void update(int v, Object valeur, WriteCallback_itf wcb) {
        try {
            Client.monitor.feuVert(Client.getIdSite(),4); // ** Instrumentation
         	// ** attente quadruplée pour les ack, pour exhiber l'inversion de valeurs
         	// getIdSite identique à getSite, mais non Remote
         	
         	// suite de la méthode update...
            this.version = v;
            this.obj = valeur;
            wcb.reponse();
        } catch (Exception e) {
        	e.printStackTrace();
        }

    }

    public void reportValue(ReadCallback_itf rcb) {
        try {
            Client.monitor.feuVert(Client.getIdSite(),1); // ** Instrumentation
            
         	// suite de la méthode reportValue... 
         	System.out.println("reportValue");
         	rcb.reponse(this.version, this.obj);
        } catch (Exception ex) {
            ex.printStackTrace();
        }

    }

    // invoked by the user program on the client node
    // passage par Client pour que les écritures soient demandées en séquence sur le site
    public void write(Object o) {
        try {
            Client.monitor.signaler("DE",Client.getIdSite(),id); // ** Instrumentation
            this.version = Client.write(id,o);
            this.obj = o;
            Client.monitor.signaler("TE",Client.getIdSite(),id); // ** Instrumentation
        } catch (RemoteException rex) {
            rex.printStackTrace();
        }
    }

    // pour simplifier (éviter les ReadCallBack actifs simultanés)
    // on évite les lectures concurrentes sur une même copie
    public synchronized Object read() {
        // déclarations méthode read....

        try {
            Client.monitor.signaler("DL",Client.getIdSite(),id); // ** Instrumentation
            //corps de la méthode read...
            ReadCallback rcb = new ReadCallback(this.version);
            Client.read(this.id, rcb);
            if(rcb.version > this.version) {
            	this.version = rcb.version;
            	this.obj = rcb.obj;
            }
            Client.monitor.signaler("TL",Client.getIdSite(),id); // ** Instrumentation
            return obj;
        } catch (RemoteException rex) {
            rex.printStackTrace();
            return null;
        }
    }

	@Override
	public int getVersion() {
		// TODO Auto-generated method stub
		return this.version;
	}

}