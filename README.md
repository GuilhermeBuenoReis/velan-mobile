# 📱 Velan Mobile

Aplicativo **Flutter** integrado à **API do Velan (Laravel)**, desenvolvido para **gerenciamento de consultas médicas (appointments)**.  
O app oferece fluxo completo de autenticação, visualização de agenda, criação de consultas e edição de perfil do usuário.

---

## 🎯 Objetivo do Projeto

Demonstrar domínio no desenvolvimento mobile com Flutter, utilizando arquitetura modular e integração com API externa.  
O Velan Mobile centraliza o gerenciamento de consultas e perfis de pacientes de forma moderna, rápida e intuitiva.

---

## ⚙️ Funcionalidades

- 🔐 **Autenticação completa** (login / cadastro)
    
- 🏠 **Tela Welcome** com introdução e acesso rápido
    
- 📅 **Agendamento de consultas** (Appointment Page)
    
- 👤 **Tela de Perfil** do usuário
    
- 🧭 **Navegação entre rotas** centralizada em `app_routes.dart`
    
- 🎨 **Layouts reutilizáveis** (`app_layout.dart`, `auth_layout.dart`)
    
- ⚙️ **Estrutura modular**, separando telas, contextos e widgets
    

---

## 🖼️ Telas e Páginas

|Tela|Caminho|Descrição|
|---|---|---|
|**WelcomePage**|`Screens/App/Pages/Welcome/welcome_page.dart`|Apresentação inicial e acesso a login ou registro|
|**LoginPage**|`Screens/Auth/Pages/login_page.dart`|Tela de autenticação com campos de e-mail e senha|
|**RegisterPage**|`Screens/Auth/Pages/register_page.dart`|Criação de nova conta de usuário|
|**AppointmentPage**|`Screens/App/Pages/Appointment/appointment_page.dart`|Listagem e criação de consultas agendadas|
|**ProfilePage**|`Screens/App/Pages/Profile/profile_page.dart`|Exibição e edição das informações do usuário|

---

## 🧩 Estrutura de Pastas

```
lib/
├── Models/                        # Modelos de dados
├── Screens/
│   ├── App/
│   │   ├── Appointment/
│   │   │   ├── Contexts/          # Lógica e estado de appointments
│   │   │   └── Widgets/           # Componentes visuais reutilizáveis
│   │   │       └── appointment_page.dart
│   │   ├── Profile/
│   │   │   └── profile_page.dart
│   │   └── Welcome/
│   │       ├── Widgets/
│   │       │   └── welcome_page.dart
│   │       └── app_layout.dart
│   └── Auth/
│       ├── Pages/
│       │   ├── login_page.dart
│       │   └── register_page.dart
│       └── Widgets/
│           └── auth_layout.dart
├── Services/
│   └── utils/
│       └── app_routes.dart        # Gerencia todas as rotas da aplicação
├── main.dart
```

---

## 🚏 Sistema de Rotas

Gerenciado em `lib/Services/utils/app_routes.dart`.

```dart
class AppRoutes {
  static const welcome = '/welcome';
  static const login = '/login';
  static const register = '/register';
  static const appointment = '/appointment';
  static const profile = '/profile';

  static Map<String, WidgetBuilder> routes = {
    welcome: (_) => const WelcomePage(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    appointment: (_) => const AppointmentPage(),
    profile: (_) => const ProfilePage(),
  };
}
```

---

## 🌐 Integração com API Velan

O app consome endpoints REST do Velan Laravel para cadastro de usuários e agendamento de consultas.

|Método|Endpoint|Função|
|---|---|---|
|`POST`|`/login`|Autenticação|
|`POST`|`/register`|Registro de novo usuário|
|`GET`|`/appointments`|Listar consultas|
|`POST`|`/appointments`|Criar nova consulta|
|`PUT`|`/appointments/:id`|Atualizar consulta|
|`GET`|`/profile`|Buscar dados do usuário|

---

## 🛠️ Tecnologias Utilizadas

- **Flutter (Dart)** – framework principal
    
- **Material Design** – UI padrão Google
    
- **Arquitetura modular** – divisão por domínio (Auth, App, Profile, Welcome)
    
- **Context API customizada** – controle de estado local
    
- **Integração com Laravel API** – consumo via HTTP
    
- **Widgets personalizados** – para reutilização de componentes
    

---

## ▶️ Como Executar

```bash
# Clone o repositório
git clone https://github.com/GuilhermeBuenoReis/velan-mobile.git
cd velan-mobile

# Instale dependências
flutter pub get

# Configure o endpoint da API em seus arquivos de serviço

# Execute o app
flutter run
```

---

## 👨‍💻 Autor

**Guilherme Bueno Reis**  
Desenvolvedor Fullstack & Mobile  
📧 [guilhermebuenoreis.contact@gmail.com](mailto:guilhermebuenoreis.contact@gmail.com)  
🌐 [github.com/GuilhermeBuenoReis](https://github.com/GuilhermeBuenoReis)

---

## 🎓 Considerações Finais

O **Velan Mobile** foi desenvolvido individualmente para a disciplina de **Programação para Dispositivos Móveis**, cumprindo todos os requisitos:

- Uso de **Flutter**
    
- Integração com API externa (Laravel)
    
- Quatro ou mais telas distintas
    
- Estrutura modular e navegação com rotas
    

O projeto reflete boas práticas de arquitetura, usabilidade e integração entre **frontend mobile** e **backend Laravel**.
