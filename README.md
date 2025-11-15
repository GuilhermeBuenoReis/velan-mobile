Velan Mobile

Aplicativo mobile desenvolvido com Flutter para consumo da API do Velan (Laravel), focado em consulta/agendamento de appointments.

Objetivo

Criar um app individual que demonstre domínio de Flutter, integração com API externa e múltiplas telas funcionais.
O Velan Mobile oferece aos usuários a capacidade de agendar consultas, visualizar um calendário de appointments, editar detalhes e gerenciar compromissos via API.

Funcionalidades

Visualização de calendário por mês/dia, com destaques para dias com appointments

Listagem de appointments de um dia selecionado

Criação de novos appointments com campos como título, data, hora, tipo de consulta, local, profissional, notas

Edição e visualização de detalhes de appointments existentes

Integração com API REST do Velan para leitura, criação e atualização de dados de appointments

Telas
Tela	Função
HomeScreen	Tela inicial com navegação para funcionalidades principais
CalendarScreen	Exibe calendário completo e permite seleção de dias com appointments
CreateAppointmentScreen	Formulário para criação de novo appointment
AppointmentDetailsScreen	Exibe todos os dados de um appointment e permite edição/modificação
Arquitetura e Organização de Código
lib/
├── context/
│   └── calendar-context.dart        ← Gerenciamento de estado e appointments
├── screens/
│   ├── home_screen.dart
│   ├── calendar_screen.dart
│   ├── create_event_screen.dart     ← (ou create_appointment_screen.dart conforme nomenclatura)
│   └── event_details_screen.dart    ← (ou appointment_details_screen.dart conforme nomenclatura)
├── widgets/
│   ├── month_view.dart
│   ├── day_view.dart
│   └── event_card.dart               ← representa visualização de appointment
└── types/
    └── event.dart                    ← (ou appointment.dart conforme nomenclatura)

Integração com API

O app consome endpoints REST da API do Velan:

GET /appointments — lista todos os appointments

GET /appointments/:id — obtém detalhes de appointment

POST /appointments — cria novo appointment

PUT /appointments/:id — atualiza appointment existente

Exemplo de objeto de appointment:

{
  "id": 1,
  "title": "Consulta de Revisão",
  "date": "2025-11-20",
  "time": "10:30",
  "type": "Revisão",
  "location": "Clínica Central",
  "professional": "Dr. Silva",
  "notes": "Levar exames"
}

Tecnologias Utilizadas

Flutter (Dart)

Material Design / UI responsiva

Gerenciamento de estado via Context customizado

Widgets personalizados (MonthView, DayView, EventCard)

Animações e transições suaves via pacote de motion

Integração com API externa (Velan Laravel) para persistência de dados de appointments

Instalação e Execução

Clone o repositório

git clone https://github.com/GuilhermeBuenoReis/velan-mobile.git
cd velan-mobile


Instale as dependências

flutter pub get


Configure a URL base da API no arquivo de requisições

Execute o app

flutter run

Autor

Guilherme Bueno Reis
Desenvolvedor Fullstack & Mobile
GitHub: https://github.com/GuilhermeBuenoReis

Considerações Finais

O Velan Mobile foi desenvolvido individualmente e demonstra integração entre frontend mobile e backend via API, além de uma fluida interface para gerenciamento de consultas/appointments com múltiplas telas e funcionalidades completas.
