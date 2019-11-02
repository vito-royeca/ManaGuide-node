const createError = require('http-errors');
const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');

// routers
const artistsRouter = require('./routes/artists');
const cardsRouter = require('./routes/cards');
const languagesRouter = require('./routes/languages');
const layoutsRouter = require('./routes/layouts');
const indexRouter = require('./routes/index');
const raritiesRouter = require('./routes/rarities');
const setsRouter = require('./routes/sets');
const setBlocksRouter = require('./routes/setblocks');
const setTypesRouter = require('./routes/settypes');
const watermarksRouter = require('./routes/watermarks');

const app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// API
app.use('/', indexRouter);
app.use('/artists', artistsRouter);
app.use('/cards', cardsRouter);
app.use('/languages', languagesRouter);
app.use('/layouts', layoutsRouter);
app.use('/rarities', raritiesRouter);
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
