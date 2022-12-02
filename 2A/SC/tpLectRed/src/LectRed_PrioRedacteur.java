// Time-stamp: <08 Apr 2008 11:35 queinnec@enseeiht.fr>

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import Synchro.Assert;

/** Lecteurs/rédacteurs
 * stratégie d'ordonnancement: priorité aux rédacteurs,
 * implantation: avec un moniteur. */
public class LectRed_PrioRedacteur implements LectRed
{

    // Protection des variables partagées
    private Lock moniteur;

    private Condition enAttente;

    private Condition sas;
    
    private boolean sasVide;
    
    private int nbLecteur;
    
    private boolean ecriture;
    
    private int nbEnAttente;
    
    public LectRed_PrioRedacteur()
    {
    	this.moniteur = new java.util.concurrent.locks.ReentrantLock();
    	this.enAttente = this.moniteur.newCondition();
    	this.sas = this.moniteur.newCondition();
    	this.nbLecteur = 0;
    	this.ecriture = false;
    	this.sasVide = true;
    	this.nbEnAttente = 0;
    	
    }

    public void demanderLecture() throws InterruptedException
    {
    	this.moniteur.lock();
    	if(this.ecriture || this.nbEnAttente != 0) {
    		this.nbEnAttente ++;
    		this.enAttente.await();
    		this.nbEnAttente --;
        	this.moniteur.unlock();
    	}
    	this.nbLecteur++;
    	this.enAttente.signal();
    }

    public void terminerLecture() throws InterruptedException
    {
    	this.moniteur.lock();
    	this.nbLecteur--;
    	if(this.nbLecteur == 0) {
    		if(!this.sasVide) {
    			this.sas.signal();
    		} else {
    			this.enAttente.signal();
    		}
    	}
    	this.moniteur.unlock();
    }

    public void demanderEcriture() throws InterruptedException
    {
    	this.moniteur.lock();
    	if(this.ecriture || this.nbLecteur > 0 || this.nbEnAttente != 0) {
    		this.nbEnAttente ++;
    		this.enAttente.await();
    		this.nbEnAttente --;
    	}
    	if(this.nbLecteur > 0) {
    		this.sasVide = false;
    		this.sas.await();
    		this.sasVide = true;
    	}
    	this.ecriture = true;
    	this.moniteur.unlock();
    }

    public void terminerEcriture() throws InterruptedException
    {
    	this.moniteur.lock();
    	this.ecriture = false;
    	this.enAttente.signal();
    	this.moniteur.unlock();
    }

    public String nomStrategie()
    {
        return "Stratégie: Priorité Rédacteurs.";
    }
}
