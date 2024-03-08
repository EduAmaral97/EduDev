/* Variáveis */

//var - escopo global
//let - escopo do bloco
//const - não modifica

/* Funções com retorno */
function dtCompetencia(DataComp) {
    
    let comp = "";

    comp = DataComp.toLocaleDateString().substr(3,2) + "/" + DataComp.toLocaleDateString().substr(6,4)

    return comp;
    
}


/* Array de objetos */ 
let arr = [
    {
        "Filial	": "MEDICAR EMERGENCIAS MEDICAS LTDA MATRIZ",
        "PerfilContrato	": "MEDICAR TOTAL FAMILIAR",
        "Número	": "TF-00033502-CT",
        "IDBenner	": "1020165",
        "RazaoSocial	": "LEIDE MARIA BENEDITO PIRES",
        "NomeFantasia	": "LEIDE MARIA BENEDITO PIRES",
        "CpfCnpj	": "747.190.098-91",
        "Status": "Aprovado"
    },
    {
        "Filial	": "MEDICAR EMERGENCIAS MEDICAS LTDA MATRIZ",
        "PerfilContrato	": "MEDICAR TOTAL FAMILIAR",
        "Número	": "TF-00033502-CT",
        "IDBenner	": "1020165",
        "RazaoSocial	": "LEIDE MARIA BENEDITO PIRES",
        "NomeFantasia	": "LEIDE MARIA BENEDITO PIRES",
        "CpfCnpj	": "747.190.098-91",
        "Status": "Aprovado"
    }
]

/* Promisses */
// .then (Utiliza uma função após a chamada da promisse)*
const MedicarPromisse =  new Promise((resolve, reject) => {
    
    let i = 1

    if (i == 1) {
        setTimeout(() => {
            resolve("Deu certo");
          }, 300);
    } else {
        reject("Deu errado");
    }
    
});


/* HTTP request */
const req = new XMLHttpRequest();
req.addEventListener("load", console,log(this.responseText));
req.open("GET", "http://www.example.org/example.txt");
req.send();
