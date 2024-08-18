import redis from "redis";
import JSONCache from "redis-json";

class Authentication {
  static async signUp(req, res) {
    let { email, password } = req.body;
    let redisClient = redis.createClient();
    let jsonCache = new JSONCache(redisClient);

    let userData = {
      email,
      password,
    };

      await jsonCache.set( email, userData);
      return res.send({
        signed: true,
        email,
        password,
      });
    
  }

  static async login(req, res) {
    const { newEmail, newpassword } = req.body;
    const redisClient = redis.createClient();
    const jsonCache = new JSONCache(redisClient);

    try {
      const userData = await jsonCache.get("user", newEmail);
      console.log(userData);

      if (userData) {
        const { useremail, userpassword } = userData;
        if (userpassword === newpassword) {
          console.log("email matched");
          return res.send({
            Authenticated: true,
          });
        } else {
          return res.send({
            Authenticated: false,
          });
        }
      } else {
        return res.send({
          Authenticated: false,
          data: "Account not found",
        });
      }
    } catch (error) {
      console.error('Error during login:', error);
      return res.status(500).send({
        error: 'Failed to authenticate user',
      });
    }
  }
}

export default Authentication;
