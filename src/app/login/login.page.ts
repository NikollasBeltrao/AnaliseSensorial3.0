import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { FormGroup, FormControl, Validators, FormBuilder } from '@angular/forms';
import { LoadingController, ToastController } from '@ionic/angular';
import { Usuario } from 'src/modal/usuario';
import { UsuarioService } from 'src/services/usuario.service';
import { NativePageTransitions, NativeTransitionOptions } from '@ionic-native/native-page-transitions/ngx';

@Component({
  selector: 'app-login',
  templateUrl: './login.page.html',
  styleUrls: ['./login.page.scss'],
})
export class LoginPage implements OnInit {
  error = "";
  tipoCampoSenha = "password";
  validar = false;
  usuario: Usuario;
  fGroup: FormGroup;
  constructor(public formBuilder: FormBuilder, private route: Router, public loading: LoadingController,
    public usuarioService: UsuarioService, public active: ActivatedRoute,
    private nativePageTransitions: NativePageTransitions,
    public toastController: ToastController) {
    this.fGroup = this.formBuilder.group({
      login: new FormControl('', Validators.required),
      senha: ['', Validators.required]
    });
  }

  ngOnInit() {

  }

  async login() {
    if (this.fGroup.valid) {
      this.validar = true;
      let load = await this.loading.create({
        message: 'Carregando',
      });
      load.present();
      await this.usuarioService.auth(this.fGroup.value.login).then(data => {
        if (data) {
          this.usuario = <Usuario>data;
          if (this.usuario.senha == this.fGroup.value.senha) {
            this.error = "";
            this.fGroup.reset();
            this.validar = false;
            let options: NativeTransitionOptions = {
              direction: 'left',
              duration: 400,
            }
            this.nativePageTransitions.slide(options)
              .catch(console.error);
            this.route.navigate(['usuario-logado', { id_user: this.usuario.id_usuario }]);
            load.dismiss();
          }
          else {
            load.dismiss();
            this.error = "Senha incorreta";
            this.presentToast("Senha incorreta");
          }
        }
        else {
          load.dismiss();
          this.error = "Usuário não cadastrado";
          this.presentToast("Usuário não cadastrado");
        }
      }, err => {
        load.dismiss();
        this.error = "Erro ao conectar ao servidor";
        this.presentToast("Erro ao conectar ao servidor");
      });
    }
    else {
      this.error = "Preencha todos os campos";
      this.presentToast("Preencha todos os campos");
    }

  }


  async presentToast(menssagem: string) {
    const toast = await this.toastController.create({
      message: menssagem,
      duration: 2000,
      color: "danger"
    });
    toast.present();
  }

  back() {
    let options: NativeTransitionOptions = {
      direction: 'right',
      duration: 400,
    }
    this.nativePageTransitions.slide(options)
      .catch(console.error);
    this.route.navigate(['home']);
  }
}
