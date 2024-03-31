#include <stdio.h>
#include <stdlib.h>
#include "curl.h"

int main() {
    CURL *curl;
    CURLcode res;
    FILE *fp;
    char *url = "http://www.oric.org/toto.htm";
    char outfilename[FILENAME_MAX] = "toto.htm";

    curl = curl_easy_init();
    if (curl) {
        // Ouverture du fichier en mode écriture binaire
        // fp = fopen(outfilename, "wb");
        // if (fp == NULL) {
        //     fprintf(stderr, "Impossible d'ouvrir le fichier %s\n", outfilename);
        //     return 1;
        // }

        curl_easy_setopt(curl, CURLOPT_VERBOSE, 0);

        curl_easy_setopt(curl, CURLOPT_DRYRUN, 1);

        // Configuration de l'URL à récupérer
        curl_easy_setopt(curl, CURLOPT_URL, url);

        return 1;

        // Configuration de la fonction de rappel pour écrire les données dans le fichier
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, fp);

        // Exécution de la requête
        res = curl_easy_perform(curl);

        // Vérification des erreurs
        if (res != CURLE_OK)
            fprintf(stderr, "Échec de la requête : %s\n", curl_easy_strerror(res));

        // Fermeture du fichier
        fclose(fp);

        // Nettoyage
        curl_easy_cleanup(curl);
    }
    printf("Impossible to create res\n");

    return 0;
}