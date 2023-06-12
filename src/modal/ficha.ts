import { Resposta } from "./resposta";

export class Ficha {
    id_ficha: number;
    nome_aluno: string;
    faixa_etaria: string;
    frequencia_consumo: number;
    genero: string;
    respostas: Array<Resposta>;
}