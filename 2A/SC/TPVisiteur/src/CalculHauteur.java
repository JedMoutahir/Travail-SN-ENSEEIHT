/** Afficheur infixe, complètement parenthésé, d'une expression arithmétique.
  *
  * @author	Xavier Crégut
  * @version	$Revision$
  */

public class CalculHauteur implements VisiteurExpression<Integer> {

	public Integer visiterAccesVariable(AccesVariable v) {
		return 1;
	}

	public Integer visiterConstante(Constante c) {
		return 1;
	}

	public Integer visiterExpressionBinaire(ExpressionBinaire e) {
		return 1 + max(e.getOperandeDroite().accepter(this), e.getOperandeGauche().accepter(this));
	}

	public Integer visiterAddition(Addition a) {
		return 0;
	}

	public Integer visiterMultiplication(Multiplication m) {
		return 0;
	}

	public Integer visiterExpressionUnaire(ExpressionUnaire e) {
		return 1 + e.getOperande().accepter(this);
	}

	public Integer visiterNegation(Negation n) {
		return 0;
	}
	
	private Integer max(Integer a, Integer b) {
		if(a > b) return a;
		return b;
	}

	@Override
	public Integer visiterSoustraction(Soustraction s) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public Integer visiterLet(Let let) {
		// TODO Auto-generated method stub
		return 0;
	}
}
