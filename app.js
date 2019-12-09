const createError = require('http-errors');
const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');
const helmet = require('helmet');
const compression = require('compression');
const rateLimit = require('express-rate-limit')
//const { body, check } = require('express-validator')

// routers
const artistsRouter = require('./routes/artists');
const cardsRouter = require('./routes/cards');
const cardFacesRouter = require('./routes/cardfaces');
const cardPartsRouter = require('./routes/cardparts');
const cardTypesRouter = require('./routes/cardtypes');
const colorsRouter = require('./routes/colors');
const componentsRouter = require('./routes/components');
const formatsRouter = require('./routes/formats');
const framesRouter = require('./routes/frames');
const frameEffectsRouter = require('./routes/frameeffects');
const languagesRouter = require('./routes/languages');
const layoutsRouter = require('./routes/layouts');
const legalitiesRouter = require('./routes/legalities');
const indexRouter = require('./routes/index');
const raritiesRouter = require('./routes/rarities');
const rulingsRouter = require('./routes/rulings');
const serverInfoRouter = require('./routes/serverinfo');
const setsRouter = require('./routes/sets');
const setBlocksRouter = require('./routes/setblocks');
const setTypesRouter = require('./routes/settypes');
const watermarksRouter = require('./routes/watermarks');

// auth routers
var userInViews = require('./lib/middleware/userinviews');
var authRouter = require('./routes/auth');
var usersRouter = require('./routes/users');

const app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');

// limiter
const limiter = rateLimit({
  windowMs: 1 * 60 * 1000, // 1 minute
  max: 10, // 10 requests,
})

// express-session
var session = require('express-session');
var sess = {
  secret: 'CHANGE THIS TO A RANDOM SECRET',
  cookie: {},
  resave: false,
  saveUninitialized: true
};
if (app.get('env') === 'production') {
  // Use secure cookies in production (requires SSL/TLS)
  sess.cookie.secure = true;

  // Uncomment the line below if your application is behind a proxy (like on Heroku)
  // or if you're encountering the error message:
  // "Unable to verify authorization request state"
  // app.set('trust proxy', 1);
}

// Configure Passport to use Auth0
var dotenv = require('dotenv');
dotenv.config();
var passport = require('passport');
var Auth0Strategy = require('passport-auth0');
var strategy = new Auth0Strategy(
    {
      domain: process.env.AUTH0_DOMAIN,
      clientID: process.env.AUTH0_CLIENT_ID,
      clientSecret: process.env.AUTH0_CLIENT_SECRET,
      callbackURL:
          process.env.AUTH0_CALLBACK_URL || 'http://192.168.1.182:1993/callback'
    },
    function (accessToken, refreshToken, extraParams, profile, done) {
      // accessToken is the token to call Auth0 API (not needed in the most cases)
      // extraParams.id_token has the JSON Web Token
      // profile has all the information from the user
      return done(null, profile);
    }
);
passport.use(strategy);
passport.serializeUser(function (user, done) {
    done(null, user);
});
passport.deserializeUser(function (user, done) {
    done(null, user);
});

// Other settings
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use(compression());
app.use(helmet());
app.use(session(sess));
app.use(passport.initialize());
app.use(passport.session());
//app.use(limiter)

// API
app.use('/', indexRouter);
app.use('/artists', artistsRouter);
app.use('/cards', cardsRouter);
app.use('/cardfaces', cardFacesRouter);
app.use('/cardparts', cardPartsRouter);
app.use('/cardtypes', cardTypesRouter);
app.use('/colors', colorsRouter);
app.use('/components', componentsRouter);
app.use('/formats', formatsRouter);
app.use('/frames', framesRouter);
app.use('/frameeffects', frameEffectsRouter);
app.use('/languages', languagesRouter);
app.use('/layouts', layoutsRouter);
app.use('/legalities', legalitiesRouter);
app.use('/rarities', raritiesRouter);
app.use('/rulings', rulingsRouter);
app.use('/serverinfo', serverInfoRouter);
app.use('/sets', setsRouter);
app.use('/setblocks', setBlocksRouter);
app.use('/settypes', setTypesRouter);
app.use('/watermarks', watermarksRouter);

// Auth API
app.use(userInViews());
app.use('/', authRouter);
app.use('/', indexRouter);
app.use('/', usersRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
