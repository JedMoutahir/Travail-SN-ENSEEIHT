import java.util.ArrayList;
import java.util.concurrent.Semaphore;

public class PhiloSemTableLimite {

    /****************************************************************/
	
	ArrayList<Semaphore> fourchettes;
	Semaphore table;
	
    public PhiloSemTableLimite (int nbPhilosophes) {
    	fourchettes = new ArrayList<Semaphore>(nbPhilosophes);
    	for(int i = 0; i < nbPhilosophes; i++) {
    		Semaphore f = new Semaphore(1, true);
    		fourchettes.add(f);
    	}
    	table = new Semaphore(nbPhilosophes-1);
    }

    /** Le philosophe no demande les fourchettes.
     *  Précondition : il n'en possède aucune.
     *  Postcondition : quand cette méthode retourne, il possède les deux fourchettes adjacentes à son assiette. */
    public void demanderFourchettes (int no) throws InterruptedException
    {
    	table.acquire();
    	if(no != 0) {
	    	fourchettes.get(Main.FourchetteDroite(no)).acquire();
	    	fourchettes.get(Main.FourchetteGauche(no)).acquire();
    	} else {
	    	fourchettes.get(Main.FourchetteGauche(no)).acquire();  
	    	fourchettes.get(Main.FourchetteDroite(no)).acquire();  		
    	}
    }

    /** Le philosophe no rend les fourchettes.
     *  Précondition : il possède les deux fourchettes adjacentes à son assiette.
     *  Postcondition : il n'en possède aucune. Les fourchettes peuvent être libres ou réattribuées à un autre philosophe. */
    public void libererFourchettes (int no)
    {
    	if(no != 0) {
	    	fourchettes.get(Main.FourchetteDroite(no)).release();
	    	fourchettes.get(Main.FourchetteGauche(no)).release();
    	} else {
	    	fourchettes.get(Main.FourchetteGauche(no)).release();  
	    	fourchettes.get(Main.FourchetteDroite(no)).release();  		
    	}
    	table.release();
    }

    /** Nom de cette stratégie (pour la fenêtre d'affichage). */
    public String nom() {
        return "Implantation Sémaphores, stratégie ???";
    }

}
