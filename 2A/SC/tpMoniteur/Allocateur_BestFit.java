// Time-stamp: <10 jan 2011 13:36 queinnec@enseeiht.fr>

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.locks.Condition;

/** Allocateur de ressources,
 * stratégie d'ordonnancement: priorité aux petits demandeurs,
 *
 * Implantation: moniteur (java 5), une var condition par taille de demande.
 */
public class Allocateur_BestFit implements Allocateur {

    // Nombre total de ressources.
    private final int nbRessources;

    // Nombre de ressources actuellement disponibles
    // invariant 0 <= nbLibres <= nbRessources
    private int nbLibres;

    // Protection des variables partagées
    private Lock moniteur;

    // Une condition de blocage par taille de demande
    // tableau [nbRessources+1] dont on n'utilise pas la case 0
    private Condition[] classe; 

    // Le nombre de processus en attente à chaque étage
    // tableau [nbRessources+1] dont on n'utilise pas la case 0
    private int[] tailleClasse;

    /** Initilialise un nouveau gestionnaire de ressources pour nbRessources. */
    public Allocateur_BestFit (int nbRessources)
    {
        this.nbRessources = nbRessources;
        this.nbLibres = nbRessources;

        this.classe = new Condition[this.nbRessources+1];
        this.tailleClasse = new int[this.nbRessources+1];
        this.moniteur = new java.util.concurrent.locks.ReentrantLock();
        
        for(int i = 1 ; i < this.nbRessources+1 ; i ++) {
        	classe[i] = this.moniteur.newCondition();
        	tailleClasse[i] = 0;
        }
    }

    /** Demande à obtenir `demande' ressources. */
    public void allouer (int demande) throws InterruptedException
    {
    	moniteur.lock();
        while(demande > this.nbLibres) {
        	this.tailleClasse[demande] ++;
        	this.classe[demande].await();
        	this.tailleClasse[demande] --;
        }
        this.nbLibres -= demande;
        reveilSuivant();
        moniteur.unlock();
    }

    private void reveilSuivant() {
		// TODO Auto-generated method stub
		int i = this.nbLibres;
		while(i > 0 && this.tailleClasse[i] == 0) {
			i--;
		}
		if(i > 0) {
			this.classe[i].signal();
		}
	}

	/** Libère `rendu' ressources. */
    public void liberer (int rendu) throws InterruptedException
    {
    	moniteur.lock();
        this.nbLibres += rendu;
        reveilSuivant();
        moniteur.unlock();
    }

    /** Chaîne décrivant la stratégie d''allocation. */
    public String nomStrategie ()
    {
        return "Priorité aux grands demandeurs";
    }

}
