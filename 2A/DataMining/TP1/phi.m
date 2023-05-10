function value = phi(I, Ibar, Q)
    value = (I - Ibar)'*Q*(I - Ibar);
end