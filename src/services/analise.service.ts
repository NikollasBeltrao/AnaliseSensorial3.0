import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Amostra } from 'src/modal/amostra';
import { Analise } from 'src/modal/analise';
import { Atributo } from 'src/modal/atributo';
import { fileURLToPath, pathToFileURL } from 'url';

@Injectable({
    providedIn: 'root'
})
export class AnaliseService {
    private server = "http://localhost/analisesensorial/";
    constructor(private http: HttpClient) { }

    listarResultados(id) {
        return new Promise<Amostra[]>((resolve, reject) => {
            this.http.get<Amostra[]>(this.server + "/analise.php", { params: { listarResultados: id } }).
                subscribe(snapshots => { resolve(snapshots); }, err => { reject(err) })
        });
    }

    getByUsuario(usuario) {
        return new Promise<Array<Analise>>((resolve, reject) => {
            this.http.get<Array<Analise>>(this.server + "/analise.php", { params: { getByUsuario: usuario } }).
                subscribe(snapshots => { resolve(snapshots); }, err => { reject(err) })
        });
    }

    changeStatus(form) {
        form.append("changeStatus", "changeStatus");
        return new Promise<any>((resolve, reject) => {
            this.http.post(this.server + "/analise.php", form).
                subscribe(snapshots => { resolve(snapshots); }, err => { reject(err) })
        });
    }

    getAnaliseById(id) {
        return new Promise<any>((resolve, reject) => {
            this.http.get(this.server + "/analise.php", { params: { getAnaliseById: id } }).
                subscribe(snapshots => { resolve(snapshots); }, err => { reject(err) })
        });
    }

    listarGraficos(id) {
        return new Promise<any>((resolve, reject) => {
            this.http.get(this.server + "/analise.php", { params: { listarGraficos: id } }).
                subscribe(snapshots => { resolve(snapshots); }, err => { reject(err) })
        });
    }

    getAnaliseByCodigo(code) {  
        return new Promise<Analise>((resolve, reject) => {
            this.http.get<Analise>(this.server + "/analise.php", { params: { getAnaliseByCodigo: code } }).
                subscribe(snapshots => { resolve(snapshots); }, err => { reject(err) })
        });
    }

    getRespostaByCodigo(code) {  
        return new Promise<any>((resolve, reject) => {
            this.http.get(this.server + "/analise.php", { params: { getRespostaByCodigo: code } }).
                subscribe(snapshots => { resolve(snapshots); }, err => { reject(err) })
        });
    }

    listarAtributos() {  
        return new Promise<Atributo[]>((resolve, reject) => {
            this.http.get<Atributo[]>(this.server + "/analise.php", { params: { listarAtributos: 'a'} }).
                subscribe(snapshots => { resolve(snapshots); }, err => { reject(err) })
        });
    }



    getAll() {
        return new Promise<any>((resolve, reject) => {
            this.http.get(this.server + "/analise/analise.php", { params: { getAll: "all" } }).
                subscribe(snapshots => { resolve(snapshots); }, err => { reject(err) })
        });
    }


    getActiveAnalises() {
        return new Promise<any>((resolve, reject) => {
            this.http.get(this.server + "/analise/analise.php", { params: { getActiveAnalises: "ActiveAnalises" } }).
                subscribe(snapshots => { resolve(snapshots); }, err => { reject(err) })
        });
    }
    getSearch(param) {
        return new Promise<any>((resolve, reject) => {
            this.http.post(this.server + "/analise/analise.php", param).
                subscribe(snapshots => { resolve(snapshots); }, err => { reject(err) })
        });
    }
    saveAnalise(form) {
        form.append("saveAnalise", "saveAnalise");
        return new Promise<any>((resolve, reject) => {
            this.http.post(this.server + "/analise/analise.php", form).
                subscribe(snapshots => { resolve(snapshots); }, err => { reject(err) })
        });
    }
    saveAmostra(form) {
        form.append("saveAmostra", "saveAmostra");
        return new Promise<any>((resolve, reject) => {
            this.http.post(this.server + "/analise/analise.php", form).
                subscribe(snapshots => { resolve(snapshots); }, err => { reject(err) })
        });
    }

    saveRespostas(form) {
        return new Promise<any>((resolve, reject) => {
            this.http.post(this.server + "/analise/analise.php", form).
                subscribe(snapshots => { resolve(snapshots); }, err => { reject(err) })
        });
    }
}