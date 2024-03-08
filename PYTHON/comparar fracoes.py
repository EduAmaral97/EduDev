import math

f1 = input("Primeira fração (Utilizar: n/n): ")
f2 = input("Segunda fração (Utilizar: n/n): ")

print('primeiro numero')
print(f1[0:f1.find('/')])
print('segundo numero')
print(f1[f1.find('/')+1:len(f1)])


resultado1 = int(f1[0:f1.find('/')]) / int(f1[f1.find('/')+1:len(f1)])
resultado2 = int(f2[0:f2.find('/')]) / int(f2[f2.find('/')+1:len(f2)])


print(resultado1)
print(resultado2)


if resultado1 > resultado2:
    print('Fracao 1 maior que fracao 2!')
elif resultado1 == resultado2:
        print('Fracao 1 e 2 sao equivalentes!')
else:
    print("Fracao 2 maior que Fracao 1!")




