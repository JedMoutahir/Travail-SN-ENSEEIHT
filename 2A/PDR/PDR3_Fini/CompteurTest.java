import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.logging.*;

public class CompteurTest {

    public static void main(String argv[]) {
        /* Logger parent = Logger.getGlobal();
        parent.setLevel(Level.SEVERE); */

        // initialize the system
		Client.init();
        Random rd = new Random();

        Compteur_itf c = (Compteur_itf) Client.lookup("Compteur");
        if (c == null) {
            Historique_itf h = (Historique_itf) Client.lookup("Historique");

            if (h == null) {
                h = (Historique_itf) Client.create(new Historique());
                Client.register("Historique", h);
            }

            c = (Compteur_itf) Client.create(new Compteur(h));
            Client.register("Compteur", c);
        }

        try {
            Thread.sleep((long)(rd.nextFloat() * 500));

            c.lock_read();
            //System.out.println("c.lock_read();");
            c.read();
            Thread.sleep((long)(rd.nextFloat() * 500));
            c.unlock();
                
            Thread.sleep((long)(rd.nextFloat() * 500));

            c.lock_write();
            //System.out.println("c.lock_write();");
            Thread.sleep((long)(rd.nextFloat() * 500));
            c.increment();
            c.unlock();
            //System.out.println("finTest");
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
	}
}

class CompteurValidation {
    public static void main(String[] argv) {
        Client.init();

        Compteur_itf s = (Compteur_itf) Client.lookup("Compteur");
        if (s == null) {
            System.out.println("Il faut d'abord lancer au moins 1 CompteurTest");
            return;
        }
        //System.out.println("before lock_read");
        s.lock_read();
        //System.out.println("after lock_read");
        System.out.println(s.read());
        s.unlock();
    }
}

interface Compteur_itf extends SharedObject_itf{
    void increment();
    int read();
    List<String> getHistorique();
}

class Compteur implements java.io.Serializable {
    private int n;
    private Historique_itf historique;

    public Compteur(Historique_itf historique) {
        this.n = 0;
        this.historique = historique;
    }
    
    public void increment() {
        this.n ++;
        this.historique.lock_write();
        this.historique.add("incremente par " + this.toString());
        this.historique.unlock();
    }

    public int read() {
        return this.n;
    }

    public List<String> getHistorique() {
        this.historique.lock_read();
        List<String> l = this.historique.get();
        this.historique.unlock();

        return l;
    }
}

interface Historique_itf extends SharedObject_itf{
    void add(String s);
    List<String> get();
}

class Historique implements java.io.Serializable {
    private List<String> historique;

    public Historique() {
        this.historique = new ArrayList<String>();
    }

    public void add(String s) {
        this.historique.add(s);
    }

    public List<String> get() {
        return this.historique;
    }
}