#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <assert.h>

/**
 * \brief obtenir le chiffre des unités d'un entier naturel.
 * \param[in] nombre le nombre dont on veut obtenir le chiffre des unités
 * \return le chiffre des unités de nombre
 * \pre nombre positif : nombre >= 0
 */
int chiffre_unites(int nombre)
{
    assert(nombre >= 0);

    return nombre % 10;
}

/**
 * \brief obtenir le chiffre des dizaines d'un entier naturel.
 * \param[in] nombre le nombre dont on veut obtenir le chiffre des dizaines
 * \return le chiffre des dizaines de nombre
 * \pre nombre positif : nombre >= 0
 */
int chiffre_dizaines(int nombre)
{
    assert(nombre >= 0);

    return nombre % 100 / 10;
}

/**
 * \brief Indiquer si une année est bissextile.
 * \param[in] annee l'année à considérer
 * \return vrai si l'année est bissextile
 * \pre année positive : annee > 0
 */
bool est_bissextile(int annee) {
    
    return annee % 4 == 0 && (annee % 100 !=0 || annee % 400 == 0);
}


////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                    NE PAS MODIFIER CE QUI SUIT...                          //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////


void test_chiffre_unites(void) {
    assert(5 == chiffre_unites(1515));
    assert(2 == chiffre_unites(142));
    assert(0 == chiffre_unites(0));
    printf("%s", "chiffre_unites... ok\n");
}

void test_chiffre_dizaines(void) {
    assert(1 == chiffre_dizaines(1515));
    assert(4 == chiffre_dizaines(142));
    assert(9 == chiffre_dizaines(91));
    assert(8 == chiffre_dizaines(80));
    assert(0 == chiffre_dizaines(7));
    assert(0 == chiffre_dizaines(0));
    printf("%s", "chiffre_dizaines... ok\n");
}


void test_annee_bissextile(void) {
    // cas simples
    assert(! est_bissextile(2019));
    assert(est_bissextile(2020));
    assert(est_bissextile(2016));

    // multiples de 100
    assert(! est_bissextile(1900));
    assert(! est_bissextile(2100));

    // multiples de 400
    assert(est_bissextile(1600));
    assert(est_bissextile(2000));
    assert(est_bissextile(2400));

    printf("%s", "annee_bissextile... ok\n");
}


int main(void) {
    test_chiffre_unites();
    test_chiffre_dizaines();
    test_annee_bissextile();
    printf("%s", "Bravo ! Tous les tests passent.\n");
    return EXIT_SUCCESS;
}
