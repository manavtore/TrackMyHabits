import express from 'express';
import {createClient} from 'redis';
import router from './route/authentication.router.js';

const client = createClient();

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

const port = process.env.PORT || 8000;
app.set("port",port);


app.use("/",router);

app.listen(
    app.get("port"), () => {
     console.log(`Server is running on port ${app.get("port")}`);
    }
    
);