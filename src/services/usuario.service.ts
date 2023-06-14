import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Usuario } from 'src/modal/usuario';

@Injectable({
    providedIn: 'root'
})
export class UsuarioService {
    private server = "http://localhost/analisesensorial/";
    constructor(private http: HttpClient) { }

    auth(login) {
        return new Promise<any>((resolve, reject) => {
            this.http.get(this.server + "/usuario.php?", { params: { login: login } }).
                subscribe(snapshots => { resolve(snapshots); }, err => { reject(err) })
        });
    }

    getById(id) {
        return new Promise<Usuario>((resolve, reject) => {
            this.http.get<Usuario>(this.server + "/usuario.php", { params: { getById: id } }).
                subscribe(snapshots => { resolve(snapshots); }, err => { reject(err) })
        });
    }



    getUser(id) {
        return new Promise<Usuario>((resolve, reject) => {
            this.http.get<Usuario>(this.server + "/usuario.php", { params: { getById: <string>id } }).
                subscribe(snapshots => { resolve(snapshots); }, err => { reject(err) })
        });
    }
    

    getAllUsers() {
        return new Promise<any>((resolve, reject) => {
            this.http.get(this.server + "/usuario.php", { params: { getAll: "all" } }).
                subscribe(snapshots => { resolve(snapshots); }, err => { reject(err) })
        });
    }
    getSearch(param) {
        return new Promise<any>((resolve, reject) => {
            this.http.post(this.server + "/usuario.php", param).
                subscribe(snapshots => { resolve(snapshots); }, err => { reject(err) })
        });
    }

    createUser(form) {
        form.append('createUser', "createUser");
        return new Promise<any>((resolve, reject) => {
            this.http.post(this.server + "/usuario.php", form).
                subscribe(snapshots => { resolve(snapshots); }, err => { reject(err) })
        });
    }
    alterUser(form) {
        form.append('alterUser', "alterUser");
        return new Promise<any>((resolve, reject) => {
            this.http.post(this.server + "/usuario.php", form).
                subscribe(snapshots => { resolve(snapshots); }, err => { reject(err) })
        });
    }
}