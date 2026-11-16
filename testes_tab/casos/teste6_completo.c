int fat(int n)
{
    int r;
    r = 1;
    while (n > 1) {
        r = r * n;
        n = n - 1;
    }
    return r;
}

void main(void)
{
    int k;
    k = input();
    if (k < 0)
        output(0);
    else
        output(fat(k));
}
