#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

/**
 * \brief Obtenir le nombres de jour d'un mois d'une année non bissextile.
 * \param[in] mois le mois considéré (de 1, janvier, à 12, décembre)
 * \return le nombre de jours du mois considéré
 */
int nb_jours_mois(int mois)
{
    int jours;
    switch (mois) {
        case 1: case 3: case 5: case 7: case 8: case 10: case 12:
            jours = 31;
            break;
        case 4: case 6: case 9: case 11:
            jours = 30;
            break;
        case 2:
            jours = 28;
            break;
        default:
            jours = 0;
    }
    return jours;
}


////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                    NE PAS MODIFIER CE QUI SUIT...                          //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

void test_nb_jours_mois() {
    assert(31 == nb_jours_mois(1));
    assert(28 == nb_jours_mois(2));
    assert(31 == nb_jours_mois(3));
    assert(30 == nb_jours_mois(4));
    assert(31 == nb_jours_mois(5));
    assert(30 == nb_jours_mois(6));
    assert(31 == nb_jours_mois(7));
    assert(31 == nb_jours_mois(8));
    assert(30 == nb_jours_mois(9));
    assert(31 == nb_jours_mois(10));
    assert(30 == nb_jours_mois(11));
    assert(31 == nb_jours_mois(12));
    printf("%s", "nb_jours_mois... ok\n");
}


int main(void) {
    test_nb_jours_mois();
    printf("%s", "Bravo ! Tous les tests passent.\n");
    return EXIT_SUCCESS;
}
