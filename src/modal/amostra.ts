import { AnaliseTeste } from "./analise_teste";

export class Amostra {
    id_amostra: number;
    numero_amostra: string;
    fk_analise: number;
    ingredientes: string;
    img_amostra: string;
    analise_teste: Array<AnaliseTeste>;
}