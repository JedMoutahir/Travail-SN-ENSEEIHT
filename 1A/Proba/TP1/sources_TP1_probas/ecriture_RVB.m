function image_RVB = ecriture_RVB(image_originale)
    canal_R = image_originale(1:2:end,2:2:end);
    canal_B = image_originale(2:2:end,1:2:end);
    canal_V = 0.5*(image_originale(1:2:end,1:2:end) + image_originale(2:2:end,2:2:end));
    image_RVB = cat(3, canal_R, canal_B, canal_V);
end