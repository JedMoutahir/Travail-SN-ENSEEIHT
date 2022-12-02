import java.util.HashMap;

/** Afficheur infixe, complètement parenthésé, d'une expression arithmétique.
  *
  * @author	Xavier Crégut
  * @version	$Revision$
  */

public class EvaluateurExpression implements VisiteurExpression<Integer> {

	HashMap<String, Integer> env;
	Integer opGauche, opDroite;
	
	public EvaluateurExpression(HashMap<String, Integer> environnement) {
		// TODO Auto-generated constructor stub
		this.env = environnement;
	}

	public Integer visiterAccesVariable(AccesVariable v) {
		return this.env.get(v.getNom());
	}

	public Integer visiterConstante(Constante c) {
		return c.getValeur();
	}

	public Integer visiterExpressionBinaire(ExpressionBinaire e) {
		int opGauche = e.getOperandeGauche().accepter(this);
		opDroite = e.getOperandeDroite().accepter(this);
		this.opGauche = opGauche;
		return e.getOperateur().accepter(this);
	}

	public Integer visiterAddition(Addition a) {
		return opGauche + opDroite;
	}

	public Integer visiterMultiplication(Multiplication m) {
		return opGauche * opDroite;
	}

	public Integer visiterExpressionUnaire(ExpressionUnaire e) {
		opDroite = e.getOperande().accepter(this);
		return e.getOperateur().accepter(this);
	}

	public Integer visiterNegation(Negation n) {
		return - opDroite;
	}

	@Override
	public Integer visiterSoustraction(Soustraction s) {
		// TODO Auto-generated method stub
		return opGauche - opDroite;
	}

	@Override
	public Integer visiterLet(Let let) {
		// TODO Auto-generated method stub
		this.env.put(let.getName(), let.getLeftValue().accepter(this));
		return let.getRightValue().accepter(this);
	}
}
