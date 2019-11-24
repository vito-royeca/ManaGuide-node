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
const setsRouter = require('./routes/sets');
const setBlocksRouter = require('./routes/setblocks');
const setTypesRouter = require('./routes/settypes');
const watermarksRouter = require('./routes/watermarks');

const app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');

// limiter
const limiter = rateLimit({
  windowMs: 1 * 60 * 1000, // 1 minute
  max: 10, // 10 requests,
})

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use(compression())
app.use(helmet())
//app.use(limiter)

// API
app.use('/', indexRouter);
app.use('/artists', artistsRouter);
app.use('/cards', cardsRouter);
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
app.use('/sets', setsRouter);
app.use('/setblocks', setBlocksRouter);
app.use('/settypes', setTypesRouter);
app.use('/watermarks', watermarksRouter);

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
