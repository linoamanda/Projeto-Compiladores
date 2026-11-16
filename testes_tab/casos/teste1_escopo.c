int x;
int v[10];

int soma(int a, int b[])
{
    int x;
    x = a + b[0];
    return x;
}

void main(void)
{
    int y;
    y = soma(x, v);
    output(y);
}
