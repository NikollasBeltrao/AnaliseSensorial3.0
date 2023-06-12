import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

import { IonicModule } from '@ionic/angular';

import { CriarUsuarioPageRoutingModule } from './criar-usuario-routing.module';

import { CriarUsuarioPage } from './criar-usuario.page';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    IonicModule,
    ReactiveFormsModule,
    CriarUsuarioPageRoutingModule
  ],
  declarations: [CriarUsuarioPage]
})
export class CriarUsuarioPageModule {}
