// Time-stamp: <08 déc 2009 08:30 queinnec@enseeiht.fr>

import java.util.ArrayList;
import java.util.concurrent.Semaphore;
 
public class PhiloSem implements StrategiePhilo {

    /****************************************************************/

	ArrayList<EtatPhilosophe> state;
	ArrayList<Semaphore> philosophes;
	Semaphore mutex;
    public PhiloSem (int nbPhilosophes) {
    	state = new ArrayList<EtatPhilosophe>(nbPhilosophes);
    	philosophes = new ArrayList<Semaphore>(nbPhilosophes);
    	for(int i = 0; i < nbPhilosophes; i++) {
    		state.add(EtatPhilosophe.Pense);
    		philosophes.add(new Semaphore(0, true));
    	}
    	mutex = new Semaphore(1, true);
    }

    /** Le philosophe no demande les fourchettes.
     *  Précondition : il n'en possède aucune.
     *  Postcondition : quand cette méthode retourne, il possède les deux fourchettes adjacentes à son assiette. */
    public void demanderFourchettes (int no) throws InterruptedException
    {
    	mutex.acquire();
    	
    	if(peutManger(no)) {
    		state.set(no,  EtatPhilosophe.Mange);
    		mutex.release();
    	} else {
    		state.set(no, EtatPhilosophe.Demande);
    		mutex.release();
    		philosophes.get(no).acquire();
    	}
    }

    /** Le philosophe no rend les fourchettes.
     *  Précondition : il possède les deux fourchettes adjacentes à son assiette.
     *  Postcondition : il n'en possède aucune. Les fourchettes peuvent être libres ou réattribuées à un autre philosophe. 
     * @throws InterruptedException */
    public void libererFourchettes (int no) throws InterruptedException
    {
    	mutex.acquire();
    	state.set(no, EtatPhilosophe.Pense);
    	if((state.get(Main.PhiloGauche(no)) == EtatPhilosophe.Demande) && peutManger(Main.PhiloGauche(no))){
    		state.set(Main.PhiloGauche(no), EtatPhilosophe.Mange);
    		philosophes.get(Main.PhiloGauche(no)).release();
    	}
    	if((state.get(Main.PhiloDroite(no)) == EtatPhilosophe.Demande) && peutManger(Main.PhiloDroite(no))){
    		state.set(Main.PhiloDroite(no), EtatPhilosophe.Mange);
    		philosophes.get(Main.PhiloDroite(no)).release();
    	}
    	mutex.release();
    }

    /** Nom de cette stratégie (pour la fenêtre d'affichage). */
    public String nom() {
        return "Implantation Sémaphores, stratégie ???";
    }
    
    public boolean peutManger(int no) {
    	return (state.get(Main.PhiloDroite(no)) != EtatPhilosophe.Mange && state.get(Main.PhiloGauche(no)) != EtatPhilosophe.Mange);
    }

}

