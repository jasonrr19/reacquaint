# 📚 Reacquaint

A.I. based bidding app that streamlines the selection process for bidders to discover and pursue tenders they have a high probability of securing.

![reacquaint home](https://github.com/user-attachments/assets/ed84fad5-87c4-4878-9acd-c417af764ad0)
![reacquaint analysispage](https://github.com/user-attachments/assets/5f4346d9-cf19-4720-968d-d7b95a0337e5)

<br>
App home: https://www.reacquaint.online/
   

## Getting Started
### Setup

Install gems
```
bundle install
```

### ENV Variables
Create `.env` file
```
touch .env
```
Inside `.env`, set these variables. For any APIs, see group Slack channel.
```
CLOUDINARY_URL=your_own_cloudinary_url_key
OPENAI_ACCESS_TOKEN=your_own_openai_access_token
```

### DB Setup
```
rails db:create
rails db:migrate
rails db:seed
```

### Run a server
```
rails s
```

## Built With
- [Rails 7](https://guides.rubyonrails.org/) - Backend / Front-end
- [Stimulus JS](https://stimulus.hotwired.dev/) - Front-end JS
- [Heroku](https://heroku.com/) - Deployment
- [PostgreSQL](https://www.postgresql.org/) - Database
- [Bootstrap](https://getbootstrap.com/) — Styling
- [Figma](https://www.figma.com) — Prototyping

## Acknowledgements
Inspired by Adi's startup/experience in the construction industry and my experience with real estate and house flipping in Las Vegas.

## Team Members
- Jason R. Rocha(https://www.linkedin.com/in/jason-rocha-37188a150/)
- Aditya Karkera
- Rafaela Yazawa
- Christopher Diaz

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
This project is licensed under the MIT License
